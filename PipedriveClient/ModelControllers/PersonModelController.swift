//
//  PersonModelController.swift
//  PipedriveClient
//
//  Created by Andrius Shiaulis on 21.08.2018.
//  Copyright © 2018 Andrius Shiaulis. All rights reserved.
//

import Foundation

// The conception of this type of controller (model controller)
// was borrowed from John Sundell article about proper encapsulation.
// https://www.swiftbysundell.com/posts/model-controllers-in-swift

/**
 Person Model Controller encapsulates or data that are needed from 'person' entity
 */
class PersonModelContoller {

    // MARK: - Properties -

    var displayName: String {
        if let fullName = person.name {
            return fullName
        }
        var compositeName = ""
        if let firstName = person.firstName {
            compositeName.append(firstName)
        }
        if let secondName = person.secondName {
            compositeName.append(secondName)
        }
        return compositeName
    }

    var organizationDisplayName: String {
        return person.organizationName ?? ""
    }

    var phoneContactCardModelControllers: [ContactCardModelController] {
        return contactCardModelControllers(for: person.phoneContactCards)
    }

    var emailContactCardModelControllers: [ContactCardModelController] {
        return contactCardModelControllers(for: person.emailContactCards)
    }

    private let person: Person

    // MARK: - Inilializaion -

    init(for person: Person) {
        self.person = person
    }

    // MARK: - Private methods -

    private func contactCardModelControllers(for contactCards:[ContactCard]?) -> [ContactCardModelController] {
        var modelControllers: [ContactCardModelController] = []
        if let contactCards = contactCards {
            for contactCard in contactCards {
                if let modelController = ContactCardModelController.init(using: contactCard) {
                    modelControllers.append(modelController)
                }
            }
        }
        return modelControllers

    }
}
