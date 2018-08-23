//
//  ApplicationModel.swift
//  PipedriveClient
//
//  Created by Andrius Shiaulis on 19.08.2018.
//  Copyright © 2018 Andrius Shiaulis. All rights reserved.
//

import Foundation
import os.log

/**
 Encapsulates all application model logic for UI
 */
protocol DataProvider {
    func updatePersonsModelsFromRemoteServer(completionHandler:@escaping (DataProviderUpdateModelResult) -> Void)
}

enum DataProviderUpdateModelResult {
    case success ([PersonModelContoller])
    case failure (Error)
}

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
    private let remoteDataFetcher: RemoteDataFetcher
    private let dataMapper: DataMapper

    private var personModelControllers:[PersonModelContoller]

    private let cacheStorage: CacheStorage?

    // MARK: - Initialization -

    init() {
        self.requestBuilder = RequestBuilder.init(usingURLScheme: ApplicationModel.urlScheme,
                                                  companyName: ApplicationModel.companyName,
                                                  apiVersion: ApplicationModel.apiVersion,
                                                  token: ApplicationModel.token)
        self.remoteDataFetcher = RemoteDataFetcher.init(using: DispatchQueue.global(qos: .userInteractive),
                                                        networkProvider: URLSessionBasedNetworkProvider())
        self.dataMapper = DataMapper.init(queue: .global(qos: .userInteractive))
        self.personModelControllers = []

        let fileManager: LocalFileManager
        do {
            try fileManager = SystemLocalFileManager()
            self.cacheStorage = CacheStorage.init(queue: .global(qos: .userInitiated), fileManager: fileManager)
        } catch {
            os_log("Failed to initiate cache storage. Error: '%@'", log: ApplicationModel.logger, type: .error, error.localizedDescription)
            self.cacheStorage = nil
        }
    }

    func setup() {

    }

    func requestAppPersonsList(completionHandler:@escaping (DataProviderUpdateModelResult) -> Void) {
        // 1. Create request URL
        guard let url = requestBuilder?.createURL(for: .person) else {
            os_log("Failed to create url for all persons list request", log: ApplicationModel.logger, type: .error)
            assertionFailure()
            completionHandler(.failure(ApplicationModelError.fatalError))
            return
        }

        // 2. Perform request by network
        remoteDataFetcher.performRequest(using: url) { [weak self] (result) in
            switch result {
            case .success(let data):
                guard let strongSelf = self else {
                    assertionFailure()
                    completionHandler(.failure(ApplicationModelError.fatalError))
                    return
                }

                // 3. Decode information from received data
                strongSelf.decodePersons(from: data, completionHandler: { (personModelControllers) in
                    if let personModelControllers = personModelControllers {
                        // 4. Save parsed information to runtime storage
                        strongSelf.personModelControllers = personModelControllers
                        // 5. Cache data to file system
                        strongSelf.cacheStorage?.cache(data: data, forCategory: .allPersons, completionHandler: { (error) in
                            if let error = error {
                                os_log("Failed to cache received data. Error: '%@'", log: ApplicationModel.logger, type: .error, error.localizedDescription)
                            }
                            else {
                                os_log("Data successfully cached.", log: ApplicationModel.logger, type: .debug)
                            }
                            completionHandler(.success(personModelControllers))
                        })
                    }
                    else {
                        os_log("Failed to get person model controllers for remote request.", log: ApplicationModel.logger, type: .error)
                        completionHandler(.failure(ApplicationModelError.unknownError))
                    }
                })
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }

    private func decodePersons(from data: Data, completionHandler:([PersonModelContoller]?) -> Void) {
        do {
            let personModelControllers = try dataMapper.decodePersons(from: data)
            completionHandler(personModelControllers)
        } catch  {
            os_log("Failed to parse data", log: ApplicationModel.logger, type: .error)
            assertionFailure()
            completionHandler(nil)
        }
    }    
}

extension ApplicationModel: DataProvider {
    func updatePersonsModelsFromRemoteServer(completionHandler: @escaping (DataProviderUpdateModelResult) -> Void) {
        requestAppPersonsList(completionHandler: completionHandler)
    }
}