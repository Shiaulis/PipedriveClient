//
//  UrlBuilder.swift
//  PipedriveClient
//
//  Created by Andrius Shiaulis on 19.08.2018.
//  Copyright © 2018 Andrius Shiaulis. All rights reserved.
//

import Foundation

class RequestBuilder {
    
    // MARK: - Properties -
    
    private let baseURL: URL
    private let apiTokenQueryItem: URLQueryItem
    
    // MARK: - Initializaion -
    
    init?(usingURLScheme urlScheme: String, companyName: String, apiVersion: String, token: String) {
        var urlComponents = URLComponents()
        urlComponents.scheme = urlScheme
        urlComponents.host = "\(companyName).pipedrive.com"
        urlComponents.path = "/\(apiVersion)"
        
        guard let url = urlComponents.url else {
            assertionFailure()
            return nil
        }
        self.baseURL = url
        self.apiTokenQueryItem = URLQueryItem(name: "api_token", value: token)
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
        
        var queryItems = pagination.queryItems
        if let otherQueryItems = otherQueryItems {
            queryItems.append(contentsOf: otherQueryItems)
        }
        queryItems.append(apiTokenQueryItem)
        urlComponents.queryItems = queryItems
        
        return urlComponents.url
    }
}

enum Endpoint {
    static private let apiVersion = "v1"
    case person
    
    var path: String {
        switch self {
        case .person: return "/\(Endpoint.apiVersion)/persons"
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
