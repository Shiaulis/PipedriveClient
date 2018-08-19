//
//  PersistentDataManager.swift
//  PipedriveClient
//
//  Created by Andrius Shiaulis on 19.08.2018.
//  Copyright © 2018 Andrius Shiaulis. All rights reserved.
//

import Foundation
import CoreData

class PersistentDataManager {

    // MARK: - Properties -

    private let persistentContainer: NSPersistentContainer

    // MARK: - Initialization -

    init() throws {
        let container = NSPersistentContainer.init(name: "PipedriveClient")
        var loadError: Error?
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                loadError = error
            }
        }
        if let loadError = loadError {
            throw PersistentDataManagerError.loadStoresFailed(error: loadError)
        }
        self.persistentContainer = container
    }

    // MARK: - Core Data Saving support

    func saveContext() throws {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            try context.save()
        }
    }
}
