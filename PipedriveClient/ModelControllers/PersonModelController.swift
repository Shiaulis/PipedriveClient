//
//  PersonModelController.swift
//  PipedriveClient
//
//  Created by Andrius Shiaulis on 21.08.2018.
//  Copyright © 2018 Andrius Shiaulis. All rights reserved.
//

import Foundation

// The conception of this type of controller was borrowed
// from John Sundell article about proper encapsulation

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
        return "some"
    }


    private let person: Person

    // MARK: - Inilializaion -

    init(for person: Person) {
        self.person = person
    }
}
