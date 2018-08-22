//
//  TestNetworkProvider.swift
//  PipedriveClientTests
//
//  Created by Andrius Shiaulis on 22.08.2018.
//  Copyright © 2018 Andrius Shiaulis. All rights reserved.
//

import Foundation
@testable import PipedriveClient

private class TestNetworkProvider: NetworkProvider {

    private let data: Data?
    private let response: URLResponse?
    private let error: Error?
    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }

    func performDataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        if url.path.count == 0 {
            completionHandler(nil, nil, nil)
            return
        }

        completionHandler(self.data, self.response, self.error)
    }
}
