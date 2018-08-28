//
//  LocalFileManager.swift
//  PipedriveClient
//
//  Created by Andrius Shiaulis on 21.08.2018.
//  Copyright © 2018 Andrius Shiaulis. All rights reserved.
//

import Foundation

/**
 Protocol describes basic file manager logic
 */
protocol LocalFileManager {
    func fileExists(at: URL) -> Bool
    func createFile(at: URL, contents: Data) -> Bool
    func removeFile(at: URL) throws
    func contentOfFile(at: URL) throws -> Data?
    var cacheDirectoryURL: URL { get }
}

/**
 Implementation LocalFileManager protocol
 using Foundation File Manager
 */
class SystemLocalFileManager: LocalFileManager {

    // MARK: - Properties -

    var cacheDirectoryURL: URL
    private let fileManager: FileManager

    // MARK: - Initialization -

    init() throws {
        self.fileManager = FileManager.default
        guard let libraryDirectoryURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else {
            assertionFailure()
            throw SystemLocalFileManagerError.failedToDetectSystemCacheDirectory
        }
        self.cacheDirectoryURL = libraryDirectoryURL.appendingPathComponent("Caches", isDirectory: true)
        var isDirectory: ObjCBool = false
        guard self.fileManager.fileExists(atPath: self.cacheDirectoryURL.path, isDirectory: &isDirectory),
            isDirectory.boolValue == true else {
                throw SystemLocalFileManagerError.failedToDetectSystemCacheDirectory
        }
    }

    // MARK: - LocalFileManager methods -

    func fileExists(at url: URL) -> Bool {
        return fileManager.fileExists(atPath: url.path)
    }

    func createFile(at url: URL, contents: Data) -> Bool {
        return fileManager.createFile(atPath: url.path, contents: contents, attributes: nil)
    }

    func removeFile(at url: URL) throws {
        try fileManager.removeItem(at: url)
    }

    func contentOfFile(at url: URL) throws -> Data? {
        return try Data(contentsOf: url)
    }
}
