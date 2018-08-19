//
//  Errors.swift
//  PipedriveClient
//
//  Created by Andrius Shiaulis on 19.08.2018.
//  Copyright © 2018 Andrius Shiaulis. All rights reserved.
//

import Foundation

enum PersistentDataManagerError: Error {
    case loadPersistentStoresFailed(withError: Error?)
}

extension PersistentDataManagerError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .loadPersistentStoresFailed(withError: _):
            return NSLocalizedString("Failed to load persistent storage", comment: "error description")
        }
    }

    var failureReason: String? {
        switch self {
        case .loadPersistentStoresFailed(withError: let error):
            if let error = error {
                return error.localizedDescription
            }
            return nil
        }
    }
}
