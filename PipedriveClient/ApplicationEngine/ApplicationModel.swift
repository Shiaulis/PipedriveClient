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
    // ======================================================================
    // To check app in your own enviroment just paste
    // below your own companyName and token
    static private let companyName = "andriusinc"
    static private let token = "d95b2a784b544f23d9ccb4c3eae9b879c91225c1"
    // ======================================================================

    static private let logger = OSLog(subsystem: LogSubsystem.applicationModel, object: ApplicationModel.self)

    private let requestBuilder: RequestBuilder?
    private let remoteDataFetcher: RemoteDataFetcher
    private let dataMapper: DataMapper
    private let cacheStorage: CacheStorage?

    private var personModelControllers:[PersonModelContoller]

    // MARK: - Initialization -

    init() {
        let parameters = RequestParameters(urlScheme: ApplicationModel.urlScheme,
                                           companyName: ApplicationModel.companyName,
                                           apiVersion: ApplicationModel.apiVersion,
                                           token: ApplicationModel.token)
        self.requestBuilder = RequestBuilder(using: parameters)
        self.remoteDataFetcher = RemoteDataFetcher(using: .global(qos: .userInteractive),
                                                   networkProvider: URLSessionBasedNetworkProvider())
        self.dataMapper = DataMapper(queue: .global(qos: .userInteractive))

        do {
            let fileManager = try SystemLocalFileManager()
            self.cacheStorage = CacheStorage(queue: .global(qos: .userInitiated), fileManager: fileManager)
        } catch {
            os_log("Failed to initiate cache storage. Error: '%@'", log: ApplicationModel.logger, type: .error, error.localizedDescription)
            self.cacheStorage = nil
        }

        self.personModelControllers = []
    }

    func setup() {
        cacheStorage?.readData(forCategory: .allPersons, completionHandler: { [weak self] (cacheReadResult) in
            switch(cacheReadResult) {
            case .failure (let error):
                os_log("Failed to read data from cache on application start. Error: '%@'",
                       log: ApplicationModel.logger,
                       type: .error,
                       error.localizedDescription)
            case .success(let data):
                decodePersons(from: data, completionHandler: { [weak self] (personModelControllers) in
                    guard let personModelControllers = personModelControllers else {
                        os_log("Failed to parse data from cache on application start.",
                               log: ApplicationModel.logger,
                               type: .error)
                        return
                    }
                    self?.personModelControllers = personModelControllers
                })
            }
        })
    }

    private func requestAppPersonsList(completionHandler:@escaping (DataProviderUpdateModelResult) -> Void) {
        // 1. Create request URL
        guard let url = requestBuilder?.createURL(for: .persons) else {
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
                strongSelf.decodePersons(from: data, completionHandler: { [weak self] (personModelControllers) in
                    if let personModelControllers = personModelControllers {
                        guard let strongSelf = self else {
                            assertionFailure()
                            return
                        }
                        // 4. Save parsed information to runtime storage
                        strongSelf.personModelControllers = personModelControllers
                        // 5. Cache data to file system
                        strongSelf.cacheStorage?.cache(data: data, for: .allPersons)

                        // 6. Pass data to completion handler
                        completionHandler(.success(personModelControllers))
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

    // MARK: - Private methods -

    private func decodePersons(from data: Data, completionHandler:([PersonModelContoller]?) -> Void) {
        do {
            let personModelControllers = try dataMapper.decodePersons(from: data)
            completionHandler(personModelControllers)
        } catch {
            os_log("Failed to parse data. Error: '%@'", log: ApplicationModel.logger, type: .error, error.localizedDescription)
            assertionFailure()
            completionHandler(nil)
        }
    }
}

extension ApplicationModel: DataProvider {
    var initialPersonsList: [PersonModelContoller] {
        return personModelControllers
    }

    func updatePersonsModelsFromRemoteServer(completionHandler: @escaping (DataProviderUpdateModelResult) -> Void) {
        requestAppPersonsList(completionHandler: completionHandler)
    }
}
