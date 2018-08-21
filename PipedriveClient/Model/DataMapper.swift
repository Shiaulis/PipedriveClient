//
//  DataMapper.swift
//  PipedriveClient
//
//  Created by Andrius Shiaulis on 20.08.2018.
//  Copyright © 2018 Andrius Shiaulis. All rights reserved.
//

import Foundation
import os.log




class DataMapper {

    // MARK: - Properties -

    static private let logger = OSLog.init(subsystem: LogSubsystem.applicationModel, object: DataMapper.self)

    private let queue: DispatchQueue
    private let decoder: JSONDecoder

    // MARK: - Initialization -

    init(queue: DispatchQueue) {
        self.queue = queue
        self.decoder = JSONDecoder.init()
    }

    func decodePersons(from data: Data) {
        let json = try? decoder.decode(PersonsListResponse.self, from: data)
        dump(json)
    }
}

/**
 For supporting wider variety of responses we should use
 some protocol that will describe common fields for different responses
 For example:

 protocol Response {
     var success: Bool { get }
     var responseData: [ResponseData]? { get }
     var additionalData: AdditionalData? { get }
     var relatedObjects: RelatedObjects? { get }
     var error: String? { get }
     var errorInfo: String? { get }
 }
 */

struct PersonsListResponse: Decodable {
    var success: Bool
    var responseData: [Person]?
    var additionalData: AdditionalData?
    var relatedObjects: RelatedObjects?
    var error: String?
    var errorInfo: String?

    enum CodingKeys: String, CodingKey {
        case success
        case responseData = "data"
        case additionalData = "additional_data"
        case relatedObjects = "related_objects"
        case error
        case errorInfo = "error_info"
    }
}

struct Person: Decodable {
    let id: Int?
    let companyID: Int?
    let sentEmailsCount: Int?
    let name: String?
    let firstName: String?
    let secondName: String?
    let phone: [ContactCard]?
    let email: [ContactCard]?
    let lastUpdated: String?
    let organizationName: String?
    enum CodingKeys: String, CodingKey {
        case id
        case companyID = "company_id"
        case sentEmailsCount = "email_messages_count"
        case name
        case firstName = "first_name"
        case secondName = "last_name"
        case phone
        case email
        case lastUpdated = "update_time"
        case organizationName = "org_name"
    }
}

struct AdditionalData: Decodable {

}

struct RelatedObjects: Decodable {
    
}

struct ContactCard: Decodable {
    let label: String?
    let value: String?
    let primary: Bool?
}
