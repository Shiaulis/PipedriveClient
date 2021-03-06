//
//  Person.swift
//  PipedriveClient
//
//  Created by Andrius Shiaulis on 21.08.2018.
//  Copyright © 2018 Andrius Shiaulis. All rights reserved.
//

import Foundation

struct Person: Decodable {
    let id: Int?
    let companyID: Int?
    let sentEmailsCount: Int?
    let name: String?
    let firstName: String?
    let secondName: String?
    let phoneContactCards: [ContactCard]?
    let emailContactCards: [ContactCard]?
    let lastUpdated: String?
    let organizationName: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case companyID = "company_id"
        case sentEmailsCount = "email_messages_count"
        case name
        case firstName = "first_name"
        case secondName = "last_name"
        case phoneContactCards = "phone"
        case emailContactCards = "email"
        case lastUpdated = "update_time"
        case organizationName = "org_name"
    }
}
