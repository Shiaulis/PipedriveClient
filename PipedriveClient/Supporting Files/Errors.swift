//
//  Errors.swift
//  PipedriveClient
//
//  Created by Andrius Shiaulis on 19.08.2018.
//  Copyright © 2018 Andrius Shiaulis. All rights reserved.
//

import Foundation

enum PersistentDataManagerError: Error {
    case loadStoresFailed(error: Error?)
    case saveContextFailed(error: Error?)
}

extension PersistentDataManagerError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .loadStoresFailed(error: _):
            return NSLocalizedString("Failed to load persistent storage", comment: "error description")
        case .saveContextFailed(error: _):
            return NSLocalizedString("Failed save data to persistent storage", comment: "error description")
        }
    }

    var failureReason: String? {
        switch self {
        case .loadStoresFailed(let error):
            return error?.localizedDescription ?? nil
        case .saveContextFailed(let error):
            return error?.localizedDescription ?? nil
        }
    }
}

enum DataMapperError: Error {
    case incorrectJsonFormat
    case detectedErrorMessageInsideJson(errorMessage: String)
}

enum CacheStorageError: Error {
    case cacheDataDoesntExist
    case failedToReadDataFromFile
    case failedToCreateCacheFile
}

enum SystemLocalFileManagerError: Error {
    case failedToDetectSystemCacheDirectory
}

enum ApplicationModelError: Error {
    case unknownError
    case fatalError
}

enum RemoteDataFetcherError: Error {
    case unknownError
}
