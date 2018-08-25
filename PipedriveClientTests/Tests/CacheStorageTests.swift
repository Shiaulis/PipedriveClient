//
//  CacheStorageTests.swift
//  PipedriveClientTests
//
//  Created by Andrius Shiaulis on 21.08.2018.
//  Copyright © 2018 Andrius Shiaulis. All rights reserved.
//

import XCTest
@testable import PipedriveClient

class CacheStorageTests: XCTestCase {

    func testCache_readFromCacheForAllPersonsRequest() {
        let cache = CacheStorage(queue: .global(qos: .background), fileManager: TestFileManager())
        let expectation = XCTestExpectation(description: "completionHandlerExpectation")
        cache.readData(forCategory: .allPersons) { (cacheReadResult) in
            switch cacheReadResult {
            case .success (let data):
                XCTAssertNotNil(data)
                XCTAssertEqual(data, TestFileManager.successfullyCreatedFileContent)
                expectation.fulfill()
            case .failure(let error):
                XCTAssertNil(error)
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 5)
    }
}
