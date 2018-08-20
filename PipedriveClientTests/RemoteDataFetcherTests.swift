//
//  RemoteDataFetcherTests.swift
//  PipedriveClientTests
//
//  Created by Andrius Shiaulis on 20.08.2018.
//  Copyright © 2018 Andrius Shiaulis. All rights reserved.
//

import XCTest
@testable import PipedriveClient

class RemoteDataFetcherTests: XCTestCase {

    static private let testData = Data(repeating: 1, count: 10)
    static private let testURL = URL.init(string: "http://test.com")

    func testFetcher_notNilData() {
        let testNetworkProvider = TestNetworkProvider.init(data: RemoteDataFetcherTests.testData,
                                                          response: nil,
                                                          error: nil)
        let remoteDataFetcher = RemoteDataFetcher.init(using: DispatchQueue.global(qos: .userInitiated), networkProvider: testNetworkProvider)

        guard let testURL = RemoteDataFetcherTests.testURL else {
            XCTAssertNil(RemoteDataFetcherTests.testURL)
            return
        }

        remoteDataFetcher.performRequest(using: testURL) { (result) in
            XCTAssertFalse(Thread.isMainThread)
            switch result {
            case .success(let data):
                XCTAssertEqual(data, RemoteDataFetcherTests.testData)

            case .failure(let error):
                XCTAssertNil(error)
                XCTFail()
            }
        }
    }
}

private class TestNetworkProvider: NetworkProvider {

    private let data: Data?
    private let response: URLResponse?
    private let error: Error?
    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }

    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        if url.path.count == 0 {
            completionHandler(nil, nil, nil)
            return
        }

        completionHandler(self.data, self.response, self.error)
    }
}
