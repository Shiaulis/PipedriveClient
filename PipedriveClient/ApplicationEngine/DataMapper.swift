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
    
    static private let logger = OSLog(subsystem: LogSubsystem.applicationModel, object: DataMapper.self)
    
    private let queue: DispatchQueue
    private let decoder: JSONDecoder
    
    // MARK: - Initialization -
    
    init(queue: DispatchQueue) {
        self.queue = queue
        self.decoder = JSONDecoder()
    }
    
    func decodePersons(from data: Data) throws -> [PersonModelContoller] {
        
        let json = try decoder.decode(PersonsListResponse.self, from: data)
        
        if let errorInsideJson = json.error {
            throw DataMapperError.detectedErrorMessageInsideJson(errorMessage: errorInsideJson)
        }

        guard json.success else {
            throw DataMapperError.unknownError
        }
        
        if let persons = json.responseData {
            return persons.map( { PersonModelContoller(for: $0) } )
        }
        else {
            // We assume that the data on server is empty
            // if we reseive succeeded response with nil data
            return []
        }
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

private struct PersonsListResponse: Decodable {
    var success: Bool
    var responseData: [Person]?
    private var additionalData: AdditionalData?
    private var relatedObjects: RelatedObjects?
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

private struct AdditionalData: Decodable { }

private struct RelatedObjects: Decodable { }
