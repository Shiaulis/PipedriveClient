//
//  ApplicationModel.swift
//  PipedriveClient
//
//  Created by Andrius Shiaulis on 19.08.2018.
//  Copyright © 2018 Andrius Shiaulis. All rights reserved.
//

import Foundation
import os.log

class ApplicationModel {

    // MARK: - Properties -
    static private let logger = OSLog.init(subsystem: LogSubsystem.applicationModel, object: ApplicationModel.self)


    private let persistentDataManager: PersistentDataManager?
    private let persistentDataManagerError: Error?

    // MARK: - Initialization -

    init() {
        do {
            try self.persistentDataManager = PersistentDataManager()
            self.persistentDataManagerError = nil
            os_log("Persistent storage initiated successfully", log: ApplicationModel.logger, type: .debug)
        } catch  {
            self.persistentDataManager = nil
            self.persistentDataManagerError = error
            os_log("Failed to initiate persistent storage. Error: '%@'", log: ApplicationModel.logger, type: .error, error.localizedDescription)
        }
    }

    func setup() {

    }

    func saveDataInPersistentStorage() {
        persistentDataManager?.saveContext()
    }
}
