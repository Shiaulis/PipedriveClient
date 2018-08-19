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
            throw PersistentDataManagerError.loadPersistentStoresFailed(withError: loadError)
        }
        self.persistentContainer = container
    }

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
