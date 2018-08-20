//
//  URLBuilderTests.swift
//  URLBuilderTests
//
//  Created by Andrius Shiaulis on 19.08.2018.
//  Copyright © 2018 Andrius Shiaulis. All rights reserved.
//

import XCTest
@testable import PipedriveClient

class URLBuilderTests: XCTestCase {

    static private let getAllPersonsURLExpectation = "https://api.pipedrive.com/v1/persons?start=0&api_token=d95b2a784b544f23d9ccb4c3eae9b879c91225c1"

    func testBuilder_getAllPersons() {
        let buildScheme = URLBuilderScheme.init(companyName: "api",
                                                endpoint: .person,
                                                pagination: Pagination.defaultPagination,
                                                apiToken: ApiToken.current)
        let urlBuilder = URLBuilder.init(using: buildScheme)
        let url = urlBuilder.url

        XCTAssertNotNil(url)
        let stringUrl = url?.absoluteString
        XCTAssertNotNil(stringUrl)
        XCTAssertEqual(stringUrl, URLBuilderTests.getAllPersonsURLExpectation)
    }
}
