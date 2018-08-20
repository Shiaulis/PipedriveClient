//
//  ApplicationModel.swift
//  PipedriveClient
//
//  Created by Andrius Shiaulis on 19.08.2018.
//  Copyright © 2018 Andrius Shiaulis. All rights reserved.
//

import Foundation
import os.log

class ApplicationModel {

    // MARK: - Properties -
    static private let urlScheme = "http"
    static private let apiVersion = "v1"
    // To check app in your own enviroment just paste
    // below your own companyName and token
    static private let companyName = "andriusinc"
    static private let token = "d95b2a784b544f23d9ccb4c3eae9b879c91225c1"
    static private let logger = OSLog.init(subsystem: LogSubsystem.applicationModel, object: ApplicationModel.self)

    private let requestBuilder: RequestBuilder?
    private let remoteDataFethcer: RemoteDataFetcher
    private let persistentDataManager: PersistentDataManager?
    private let persistentDataManagerError: Error?

    // MARK: - Initialization -

    init() {
        do {
            try self.persistentDataManager = PersistentDataManager()
            self.persistentDataManagerError = nil
            os_log("Persistent storage initiated successfully", log: ApplicationModel.logger, type: .debug)
        } catch  {
            self.persistentDataManager = nil
            self.persistentDataManagerError = error
            os_log("Failed to initiate persistent storage. Error: '%@'. Reason: '%@'.", log: ApplicationModel.logger, type: .error, error.localizedDescription, error.failureReason)
            assertionFailure()
        }
        self.requestBuilder = RequestBuilder.init(usingURLScheme: ApplicationModel.urlScheme,
                                                  companyName: ApplicationModel.companyName,
                                                  apiVersion: ApplicationModel.apiVersion,
                                                  token: ApplicationModel.token)
        self.remoteDataFethcer = RemoteDataFetcher.init(using: DispatchQueue.global(qos: .userInteractive),
                                                        networkProvider: URLSessionBasedNetworkProvider())
    }

    func setup() {
        requestAppPersonsList()
    }

    func requestAppPersonsList() {
        guard let url = requestBuilder?.createURL(for: .person) else {
            os_log("Failed to create url for all persons list request", log: ApplicationModel.logger, type: .error)
            assertionFailure()
            return
        }

        remoteDataFethcer.performRequest(using: url) { (result) in

        }
    }

    func saveDataInPersistentStorage() {
        do {
            try persistentDataManager?.saveContext()
        } catch {
            os_log("Failed to save data to persistent storage. Error: '%@'. Reason: '%@'.", log: ApplicationModel.logger, type: .error, error.localizedDescription, error.failureReason)
            assertionFailure()
        }
    }

    
}
