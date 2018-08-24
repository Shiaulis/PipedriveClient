//
//  ContactCardModelController.swift
//  PipedriveClient
//
//  Created by Andrius Shiaulis on 23.08.2018.
//  Copyright © 2018 Andrius Shiaulis. All rights reserved.
//

import Foundation

struct ContactCardModelController {

    // MARK: - Properties -

    var value: String {
        return contactCard.value ?? ""
    }

    var label: String {
        return contactCard.label ?? ""
    }

    var isPrimary: Bool {
        return contactCard.primary ?? false
    }

    private let contactCard: ContactCard

    // MARK: - Initialization -

    init(using contactCard: ContactCard) {
        self.contactCard = contactCard
    }
}
