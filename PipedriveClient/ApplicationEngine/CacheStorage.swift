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
    var name: String {
        return self.rawValue
    }
}

/**
 Encapculate read cache action result
 */
enum CacheReadResult {
    case success(Data)
    case failure(Error)
}


class CacheStorage {

    // MARK: - Properties -

    static private let logger = OSLog.init(subsystem: LogSubsystem.applicationModel, object: CacheStorage.self)

    // Private
    private let dispatchQueue: DispatchQueue
    private let fileManager: LocalFileManager
    private let destinationCacheDirectoryURL: URL
    private var runtimeCache: [CacheCategory:Data]


    // MARK: - Initialization -

    init(queue: DispatchQueue, fileManager: LocalFileManager) {
        self.fileManager = fileManager
        self.destinationCacheDirectoryURL = fileManager.cacheDirectoryURL
        self.dispatchQueue = queue
        self.runtimeCache = [:]
        getDataFromPersistentToRuntimeStorage()
    }

    // MARK: - Public methods -


    func readData(forCategory category: CacheCategory, completionHandler:(CacheReadResult) -> Void) {
        if let dataFromRuntimeCache = dataFromRuntimeCache(for: .allPersons) {
            completionHandler(.success(dataFromRuntimeCache))
            return
        }
        readDataFromPersistentCache(for: category) { (cacheReadResult) in
            switch cacheReadResult {
            case .success(let data):
                saveDataToRuntimeCache(data: data, for: category)
                completionHandler(cacheReadResult)
            default:
                completionHandler(cacheReadResult)
            }
        }
    }

    func cache(data: Data, for category: CacheCategory) {
        saveDataToRuntimeCache(data: data, for: category)
        saveDataToPersistentCache(data: data, forCategory: category)
    }

    // MARK: - Private methods -

    private func generateURL(for category: CacheCategory) -> URL {
        switch category {
        case .allPersons: return destinationCacheDirectoryURL.appendingPathComponent(CacheCategory.allPersons.name, isDirectory: true)
        }
    }

    // MARK: Runtime cache methods

    private func dataFromRuntimeCache(for category: CacheCategory) -> Data? {
        return dispatchQueue.sync { [weak self] in
            return self?.runtimeCache[category]
        }
    }

    private func saveDataToRuntimeCache(data: Data, for category: CacheCategory) {
        dispatchQueue.sync { [weak self] in
            self?.runtimeCache[category] = data
        }
    }

    // MARK: Persistent cache methods

    private func getDataFromPersistentToRuntimeStorage() {
        let category: CacheCategory = .allPersons
        fillRuntimeStorageWithDataFromPersistentStorageIfPossible(for: category)
    }

    private func fillRuntimeStorageWithDataFromPersistentStorageIfPossible(for category: CacheCategory) {
        if isPersistentDataExist(for: category) == false {
            os_log("No cache file for category '%@' found", log: CacheStorage.logger, type: .default, category.name)
            return
        }

        readDataFromPersistentCache(for: category) { (cacheReadResult) in
            switch cacheReadResult {
            case .failure(let error):
                os_log("Failed to read data from persistent cache for category '%@'. Error: '%@'.",
                       log: CacheStorage.logger,
                       type: .error,
                       category.name,
                       error.localizedDescription)
            case .success(let data):
                os_log("Data from persistent cache successfully read.", log: CacheStorage.logger, type: .debug)
                runtimeCache[category] = data
            }
        }
    }

    private func saveDataToPersistentCache(data: Data, forCategory category: CacheCategory) {
        dispatchQueue.sync { [weak self] in
            guard let strongSelf = self else {
                assertionFailure()
                return
            }
            let url = strongSelf.generateURL(for: category)
            do {
                if strongSelf.fileManager.fileExists(at: url) {
                    try strongSelf.fileManager.removeFile(at: url)
                }
                if strongSelf.fileManager.createFile(at: url, contents: data) == false {
                    throw CacheStorageError.failedToCreateCacheFile
                }
                os_log("Data successfully cached at path '%@'", log: CacheStorage.logger, type: .debug, url.path)
            }
            catch {
                os_log("Failed to cache data at path '%@'. Error: '%@'", log: CacheStorage.logger, type: .error, url.path, error.localizedDescription)
            }
        }
    }

    private func readDataFromPersistentCache(for category: CacheCategory, completionHandler:(CacheReadResult) -> Void) {
        dispatchQueue.sync { [weak self] in
            guard let strongSelf = self else {
                assertionFailure()
                return
            }

            if strongSelf.isPersistentDataExist(for: category) == false {
                assertionFailure("We should check the information before calling this methods")
                completionHandler(.failure(CacheStorageError.cacheDataDoesntExist))
                return
            }

            let url = strongSelf.generateURL(for: category)
            if strongSelf.fileManager.fileExists(at: url) == false {
                completionHandler(.failure(CacheStorageError.cacheDataDoesntExist))
                return
            }

            do {
                guard let data = try strongSelf.fileManager.contentOfFile(at: url) else {
                    completionHandler(.failure(CacheStorageError.failedToReadDataFromFile))
                    return
                }
                completionHandler(.success(data))
            }
            catch {
                completionHandler(.failure(error))
            }
        }
    }

    private func isPersistentDataExist(for category: CacheCategory) -> Bool {
        return dispatchQueue.sync {
            let url = generateURL(for: category)
            return fileManager.fileExists(at: url)
        }
    }
}
