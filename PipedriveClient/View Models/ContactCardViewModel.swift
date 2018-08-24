//
//  ContactDetailsViewModel.swift
//  PipedriveClient
//
//  Created by Andrius Shiaulis on 23.08.2018.
//  Copyright © 2018 Andrius Shiaulis. All rights reserved.
//

import Foundation

struct ContactCardViewModel {

    // MARK: - Properties -

    var descriptionLabelText: String {
        return modelController.label
    }
    var  valueLabelText: String {
        return modelController.value
    }

    private let modelController: ContactCardModelController

    // MARK: - Initialization -

    init(using modelController: ContactCardModelController) {
        self.modelController = modelController
    }
}
