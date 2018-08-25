//
//  DataProvider.swift
//  PipedriveClient
//
//  Created by Andrius Shiaulis on 24.08.2018.
//  Copyright © 2018 Andrius Shiaulis. All rights reserved.
//

import Foundation

/**
 Encapsulates all application model logic for UI
 */
protocol DataProvider {
    var initialPersonsList: [PersonModelContoller] { get }
    func updatePersonsModelsFromRemoteServer(completionHandler:@escaping (DataProviderUpdateModelResult) -> Void)
}

enum DataProviderUpdateModelResult {
    case success ([PersonModelContoller])
    case failure (Error)
}
