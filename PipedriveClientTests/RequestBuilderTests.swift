//
//  RequestBuilderTests.swift
//  RequestBuilderTests
//
//  Created by Andrius Shiaulis on 19.08.2018.
//  Copyright © 2018 Andrius Shiaulis. All rights reserved.
//

import XCTest
@testable import PipedriveClient

class RequestBuilderTests: XCTestCase {

    static private let testURLScheme = "https"
    static private let companyName = "api"
    static private let apiVersion = "v1"
    static private let token = "d95b2a784b544f23d9ccb4c3eae9b879c91225c1"
    static private let getAllPersonsURLExpectation = "https://api.pipedrive.com/v1/persons?start=0&api_token=d95b2a784b544f23d9ccb4c3eae9b879c91225c1"

    func testBuilder_createRequestBuilder() {
        let requestBuilder = RequestBuilder.init(usingURLScheme: RequestBuilderTests.testURLScheme,
                                                 companyName: RequestBuilderTests.companyName,
                                                 apiVersion: RequestBuilderTests.apiVersion,
                                                 token: RequestBuilderTests.token)
        XCTAssertNotNil(requestBuilder)
    }

    func testBuilder_createRequest() {
        let requestBuilder = RequestBuilder.init(usingURLScheme: RequestBuilderTests.testURLScheme,
                                                 companyName: RequestBuilderTests.companyName,
                                                 apiVersion: RequestBuilderTests.apiVersion,
                                                 token: RequestBuilderTests.token)
        XCTAssertNotNil(requestBuilder)
        let url = requestBuilder?.createURL(for: .person, pagination: Pagination.defaultPagination, otherQueryItems: nil)

        guard let receivedURL = url else {
            XCTAssertNotNil(url)
            return
        }

        XCTAssertEqual(receivedURL.absoluteString, RequestBuilderTests.getAllPersonsURLExpectation)
    }
}
