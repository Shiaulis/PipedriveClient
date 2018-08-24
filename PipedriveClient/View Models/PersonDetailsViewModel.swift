//
//  PersonDetailsViewModel.swift
//  PipedriveClient
//
//  Created by Andrius Shiaulis on 23.08.2018.
//  Copyright © 2018 Andrius Shiaulis. All rights reserved.
//

import Foundation

struct PersonDetailsViewModel {

    // MARK: - Properties -

    var personNameLabelText: String {
        return modelController.displayName
    }

    var organizationNameLabelText: String {
        return modelController.organizationDisplayName
    }

    var shouldPresentContactsSection: Bool {
        return contactCardViewModels.count > 0
    }

    var contactCardViewModels: [ContactCardViewModel] {
        return emailContactCardViewModels + phoneContactCardViewModels
    }

    private var emailContactCardViewModels: [ContactCardViewModel] {
        return modelController.emailContactCardModelControllers.map({ContactCardViewModel(using: $0)})
    }

    private var phoneContactCardViewModels: [ContactCardViewModel] {
        return modelController.phoneContactCardModelControllers.map({ContactCardViewModel(using: $0)})
    }

    private let modelController: PersonModelContoller

    // MARK: - Initialization -

    init(using modelController: PersonModelContoller) {
        self.modelController = modelController
    }
}
