//
//  Errors.swift
//  PipedriveClient
//
//  Created by Andrius Shiaulis on 19.08.2018.
//  Copyright © 2018 Andrius Shiaulis. All rights reserved.
//

import Foundation

enum DataMapperError: Error {
    case unknownError
    case detectedErrorMessageInsideJson(errorMessage: String)
}

extension DataMapperError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .unknownError:
            return NSLocalizedString("Failed to perform data mapping.", comment: "Data mapper error")
        case .detectedErrorMessageInsideJson (let error):
            return String(format: NSLocalizedString("Error is detected in response. Error: '%@'", comment: "Data mapper error") ,
                error)
        }
    }
}

enum CacheStorageError: Error {
    case cacheDataDoesntExist
    case failedToReadDataFromFile
    case failedToCreateCacheFile
}

extension CacheStorageError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .cacheDataDoesntExist:
            return NSLocalizedString("Failed to find data in cache.", comment: "Cache storage error")
        case .failedToReadDataFromFile:
            return NSLocalizedString("Failed to read data from file.", comment: "Cache storage error")
        case .failedToCreateCacheFile:
            return NSLocalizedString("Failed to createn cache file.", comment: "Cache storage error")
        }
    }
}

enum SystemLocalFileManagerError: Error {
    case failedToDetectSystemCacheDirectory
}

extension SystemLocalFileManagerError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .failedToDetectSystemCacheDirectory:
            return NSLocalizedString("Failed to detect system cache directory.", comment: "File manager error")
        }
    }
}

enum ApplicationModelError: Error {
    case unknownError
    case fatalError
}

extension ApplicationModelError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .unknownError:
            return NSLocalizedString("Unknown error.", comment: "Application model error")
        case .fatalError:
            return NSLocalizedString("Fatal error.", comment: "Application model error")
        }
    }
}

enum RemoteDataFetcherError: Error {
    case unknownError
}

extension RemoteDataFetcherError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .unknownError:
            return NSLocalizedString("Failed fetch the data from remote server.", comment: "Remote data fethcer error")
        }
    }
}
