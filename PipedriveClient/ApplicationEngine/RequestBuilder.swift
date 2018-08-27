//
//  UrlBuilder.swift
//  PipedriveClient
//
//  Created by Andrius Shiaulis on 19.08.2018.
//  Copyright © 2018 Andrius Shiaulis. All rights reserved.
//

import Foundation

struct RequestBuilderInitialParameters {
    let urlScheme: String
    let companyName: String
    let apiVersion: String
    let token: String
}

class RequestBuilder {
    
    // MARK: - Properties -
    
    private let baseURL: URL
    private let apiTokenQueryItem: URLQueryItem
    
    // MARK: - Initializaion -
    
    init?(using parameters: RequestBuilderInitialParameters) {
        var urlComponents = URLComponents()
        urlComponents.scheme = parameters.urlScheme
        urlComponents.host = "\(parameters.companyName).pipedrive.com"
        urlComponents.path = "/\(parameters.apiVersion)"
        
        guard let url = urlComponents.url else {
            assertionFailure()
            return nil
        }
        self.baseURL = url
        self.apiTokenQueryItem = URLQueryItem(name: "api_token", value: parameters.token)
    }
    
    // MARK: - Public methods -
    
    func createURL(for endpoint: Endpoint, pagination: Pagination = Pagination.defaultPagination, otherQueryItems:[URLQueryItem]? = nil) -> URL? {
        guard let endpointURL = URL(string: endpoint.path, relativeTo: baseURL) else {
            assertionFailure()
            return nil
        }
        
        guard var urlComponents = URLComponents(url: endpointURL, resolvingAgainstBaseURL: true) else {
            assertionFailure()
            return nil
        }

        var queryItems: [URLQueryItem]
        if let otherQueryItems = otherQueryItems {
            queryItems = otherQueryItems
        }
        else {
            queryItems = []
        }

        if pagination.queryItems.count > 0 {
            queryItems.append(contentsOf: pagination.queryItems)
        }

        queryItems.append(apiTokenQueryItem)
        urlComponents.queryItems = queryItems
        
        return urlComponents.url
    }
}

enum Endpoint {
    static private let apiVersion = "v1"
    case persons
    
    var path: String {
        switch self {
        case .persons: return "/\(Endpoint.apiVersion)/persons"
        }
    }
}

struct Pagination {
    private let startQueryItem: URLQueryItem
    private let limitQueryItem: URLQueryItem?
    static let defaultPagination = Pagination(start: 0)
    
    init(start: UInt, limit: UInt = 0) {
        self.startQueryItem = URLQueryItem(name: "start", value: String(start))
        if limit > 0 {
            self.limitQueryItem = URLQueryItem(name: "limit", value: String(limit))
        }
        else {
            self.limitQueryItem = nil
        }
    }
    
    var queryItems: [URLQueryItem] {
        var queryItems = [startQueryItem]
        if let limitQueryItem = limitQueryItem {
            queryItems.append(limitQueryItem)
        }
        return queryItems
    }
}
