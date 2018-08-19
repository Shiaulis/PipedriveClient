//
//  ApplicationModel.swift
//  PipedriveClient
//
//  Created by Andrius Shiaulis on 19.08.2018.
//  Copyright © 2018 Andrius Shiaulis. All rights reserved.
//

import Foundation

class ApplicationModel {

    // MARK: - Properties -

    private let persistenDataManager: PersistentDataManager

    // MARK: - Initialization -

    init() {
        self.persistenDataManager = PersistentDataManager()
    }

    func setup() {

    }

    func saveDataInPersistentStorage() {
        persistenDataManager.saveContext()
    }
}
