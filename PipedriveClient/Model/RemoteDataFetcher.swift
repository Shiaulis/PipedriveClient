//
//  RemoteDataFetcher.swift
//  PipedriveClient
//
//  Created by Andrius Shiaulis on 19.08.2018.
//  Copyright © 2018 Andrius Shiaulis. All rights reserved.
//

import Foundation

enum RemoteRequestResult {
    case success(Data)
    case failure(Error?)
}

class RemoteDataFetcher {

    private let queue: DispatchQueue
    private let networkProvider: NetworkProvider

    init(using queue:DispatchQueue, networkProvider: NetworkProvider) {
        self.queue = queue
        self.networkProvider = networkProvider
    }

    func performRequest(using url: URL, completionHandler: @escaping (RemoteRequestResult) -> Void) {
        queue.async { [weak self] in
            self?.networkProvider.dataTask(with: url, completionHandler: { (data, response, error) in
                if let error = error {
                    let result = RemoteRequestResult.failure(error)
                    completionHandler(result);
                    return
                }

                guard let receivedData = data, receivedData.count > 0 else {
                    let result = RemoteRequestResult.failure(nil)
                    assertionFailure()
                    completionHandler(result);
                    return
                }

                let result = RemoteRequestResult.success(receivedData)
                completionHandler(result)
            })

        }
    }
}

/**
 Protocol encapsulates URLSession and provide an ability to test RemoteDataFetcher
 */

protocol NetworkProvider {
    func dataTask(with: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
}
