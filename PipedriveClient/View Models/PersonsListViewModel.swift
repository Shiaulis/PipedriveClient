//
//  PersonsListViewModel.swift
//  PipedriveClient
//
//  Created by Andrius Shiaulis on 22.08.2018.
//  Copyright © 2018 Andrius Shiaulis. All rights reserved.
//

import Foundation

class PersonsListViewModel {

    // MARK: - Properties -

    private let dataProvider: DataProvider

    // MARK: - Initialization -

    init(using dataProvider: DataProvider) {
        self.dataProvider = dataProvider
    }
}
