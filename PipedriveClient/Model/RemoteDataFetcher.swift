//
//  RemoteDataFetcher.swift
//  PipedriveClient
//
//  Created by Andrius Shiaulis on 19.08.2018.
//  Copyright © 2018 Andrius Shiaulis. All rights reserved.
//

import Foundation
import os.log

enum RemoteRequestResult {
    case success(Data)
    case failure(Error?)
}

class RemoteDataFetcher {

    static private let logger = OSLog.init(subsystem: LogSubsystem.applicationModel, object: RemoteDataFetcher.self)
    private let queue: DispatchQueue
    private let networkProvider: NetworkProvider

    init(using queue:DispatchQueue, networkProvider: NetworkProvider) {
        self.queue = queue
        self.networkProvider = networkProvider
    }

    func performRequest(using url: URL, completionHandler: @escaping (RemoteRequestResult) -> Void) {
        queue.async { [weak self] in
            os_log("Request for data at url '%@' started.", log: RemoteDataFetcher.logger, type: .debug, url.absoluteString)
            self?.networkProvider.dataTask(with: url, completionHandler: { (data, response, error) in
                if let error = error {
                    os_log("Failed to perform request for URL '%@'. Error: '%@'. Response: '%@'",
                           log: RemoteDataFetcher.logger,
                           type: .error,
                           url.absoluteString, error.localizedDescription, response ?? "")
                    let result = RemoteRequestResult.failure(error)
                    completionHandler(result);
                    return
                }

                guard let receivedData = data, receivedData.count > 0 else {
                    os_log("Failed to get data from request for URL '%@'. Response: '%@'",
                           log: RemoteDataFetcher.logger,
                           type: .error,
                           url.absoluteString, response ?? "")

                    let result = RemoteRequestResult.failure(nil)
                    assertionFailure()
                    completionHandler(result);
                    return
                }

                os_log("Request for url '%@' succeeded.", log: RemoteDataFetcher.logger, type: .debug, url.absoluteString)
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
