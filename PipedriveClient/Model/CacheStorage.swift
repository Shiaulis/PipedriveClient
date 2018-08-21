//
//  CacheStorage.swift
//  PipedriveClient
//
//  Created by Andrius Shiaulis on 21.08.2018.
//  Copyright © 2018 Andrius Shiaulis. All rights reserved.
//

import Foundation
import os.log

/**
 Cache category provides an ability to save different
 received data for different key
 */
enum CacheCategory: String {
    case allPersons
    var directoryName: String {
        return self.rawValue
    }
}

/**
 Encapculate read cache action result
 */
enum CacheReadResult {
    case success(Data)
    case failure(Error?)
}


class CacheStorage {

    // MARK: - Properties -

    static private let logger = OSLog.init(subsystem: LogSubsystem.applicationModel, object: CacheStorage.self)

    // Public
    // Private
    private let dispatchQueue: DispatchQueue
    private let fileManager: LocalFileManager
    private let destinationCacheDirectoryURL: URL

    // MARK: - Initialization -

    init(queue: DispatchQueue, fileManager: LocalFileManager) throws {
        self.fileManager = fileManager
        self.destinationCacheDirectoryURL = fileManager.cacheDirectoryURL
        self.dispatchQueue = queue
    }

    // MARK: - Public methods -

    func cache(data: Data, forCategory category: CacheCategory, completionHandler:(Error?) -> Void) throws {
        dispatchQueue.sync { [weak self] in
            guard let strongSelf = self else {
                assertionFailure()
                return
            }
            let url = strongSelf.url(forCategory: category)
            do {
                if strongSelf.fileManager.fileExists(at: url) {
                    try strongSelf.fileManager.removeFile(at: url)
                }
                if strongSelf.fileManager.createFile(at: url, contents: data) == false {
                    throw CacheStorageError.failedToCreateCacheFile
                }
                os_log("Data successfully cached at path '%@'", log: CacheStorage.logger, type: .debug, url.path)
                completionHandler(nil)
            }
            catch {
                os_log("Failed to cache data at path '%@'. Error: '%@'", log: CacheStorage.logger, type: .error, url.path, error.localizedDescription)
                completionHandler(error)
            }
        }
    }

    func readData(forCategory category: CacheCategory, completionHandler:(CacheReadResult) -> Void) {
        dispatchQueue.sync { [weak self] in
            guard let strongSelf = self else {
                assertionFailure()
                return
            }

            let url = strongSelf.url(forCategory: category)
            if strongSelf.fileManager.fileExists(at: url) == false {
                completionHandler(.failure(CacheStorageError.cacheDataDoesntExist))
                return
            }

            do {
                guard let data = try strongSelf.fileManager.contentOfFile(at: url) else {
                    completionHandler(CacheReadResult.failure(CacheStorageError.failedToReadDataFromFile))
                    return
                }
                completionHandler(CacheReadResult.success(data))
            }
            catch {
                completionHandler(CacheReadResult.failure(error))
            }
        }
    }

    // MARK: - Private methods -

    private func url(forCategory category: CacheCategory) -> URL {
        switch category {
        case .allPersons: return destinationCacheDirectoryURL.appendingPathComponent(CacheCategory.allPersons.directoryName, isDirectory: true)
        }
    }
}
