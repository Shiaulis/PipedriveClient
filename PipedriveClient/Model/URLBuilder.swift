//
//  UrlBuilder.swift
//  PipedriveClient
//
//  Created by Andrius Shiaulis on 19.08.2018.
//  Copyright © 2018 Andrius Shiaulis. All rights reserved.
//

import Foundation

class URLBuilder {

    private let urlBuilderScheme: URLBuilderScheme

    init(using scheme: URLBuilderScheme = URLBuilderScheme.defaultScheme) {
        self.urlBuilderScheme = scheme
    }

    func buildURL() -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https://"
        urlComponents.host = "pipedrive.com"
        urlComponents.path = urlBuilderScheme.endpoint.path

        urlComponents.queryItems = urlBuilderScheme.pagination.queryItems
        urlComponents.queryItems?.append(urlBuilderScheme.apiToken.queryItem)

        return urlComponents.url
    }
}

struct URLBuilderScheme {
    let endpoint: Endpoint
    let pagination: Pagination
    let apiToken: ApiToken

    static let defaultScheme = URLBuilderScheme.init(endpoint: Endpoint.person,
                                                     pagination: Pagination.defaultPagination,
                                                     apiToken: ApiToken.current)
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
    static let defaultPagination = Pagination.init(start: 1)

    init(start: UInt, limit: UInt = 0) {
        self.startQueryItem = URLQueryItem.init(name: "start", value: String(start))
        if limit > 0 {
            self.limitQueryItem = URLQueryItem.init(name: "limit", value: String(limit))
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

enum ApiToken {
    case current
    var queryItem: URLQueryItem {
        switch self {
        case .current: return URLQueryItem.init(name: "api_token", value: "d95b2a784b544f23d9ccb4c3eae9b879c91225c1")
        }
    }
}


