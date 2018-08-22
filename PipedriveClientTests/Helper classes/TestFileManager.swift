//
//  TestFileManager.swift
//  PipedriveClientTests
//
//  Created by Andrius Shiaulis on 22.08.2018.
//  Copyright © 2018 Andrius Shiaulis. All rights reserved.
//

import Foundation
@testable import PipedriveClient

class TestFileManager: LocalFileManager {

    static let existedFilePath = "/test/allPersons"
    static let nonExistedFilePath = "/test/nonExistedFile"
    static let successfullyCreatedFilePath = "/test/allPersons"
    static var successfullyCreatedFileContent: Data {
        return TestFileManager.successfullyCreatedFilePath.data(using: String.Encoding.unicode)!
    }
    static let successfullyRemotedFilePath = "/test/allPersons"
    static let cacheDirectoryPath = "/test"

    init() {}

    func fileExists(at url: URL) -> Bool {
        return url.path == TestFileManager.existedFilePath
    }

    func createFile(at url: URL, contents: Data) -> Bool {
        if url.path != TestFileManager.successfullyCreatedFilePath {
            return false
        }

        if contents != TestFileManager.successfullyCreatedFileContent {
            return false
        }

        return true
    }

    func removeFile(at url: URL) throws {
        if url.path != TestFileManager.successfullyRemotedFilePath {
            throw TestFileManagerError.failedToRemoteFile
        }
    }

    func contentOfFile(at url: URL) throws -> Data? {
        if url.path != TestFileManager.successfullyCreatedFilePath {
            throw TestFileManagerError.fileDoesntExist
        }

        return TestFileManager.successfullyCreatedFileContent
    }

    var cacheDirectoryURL: URL {
        return URL.init(string: TestFileManager.cacheDirectoryPath)!
    }
}

enum TestFileManagerError: Error {
    case failedToRemoteFile
    case fileDoesntExist
}
