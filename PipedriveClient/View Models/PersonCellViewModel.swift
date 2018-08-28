//
//  PersonCellViewModel.swift
//  PipedriveClient
//
//  Created by Andrius Shiaulis on 23.08.2018.
//  Copyright © 2018 Andrius Shiaulis. All rights reserved.
//

import Foundation

struct PersonCellViewModel {

    // MARK: - Properties -
    
    var titleLabelText: String {
        return modelController.displayName
    }

    var subtitleLabelText: String {
        return modelController.organizationDisplayName
    }

    private let modelController: PersonModelContoller

    // MARK: - Initialization -

    init(using modelController: PersonModelContoller) {
        self.modelController = modelController
    }
}
