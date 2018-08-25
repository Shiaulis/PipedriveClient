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

    var showAlertBlock: (() -> Void)?
    var updateLoadingStatus: (() -> Void)?
    var reloadTableViewBlock: (() -> Void)?

    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    var alertMessage: String? {
        didSet {
            self.showAlertBlock?()
        }
    }
    var numberOfCells: Int {
        return personModelControllers.count
    }

    private let dataProvider: DataProvider
    private var personModelControllers: [PersonModelContoller] {
        didSet {
            self.reloadTableViewBlock?()
        }
    }

    // MARK: - Initialization -

    init(using dataProvider: DataProvider) {
        self.dataProvider = dataProvider
        self.personModelControllers = dataProvider.initialPersonsList.sorted()
    }

    // MARK: - Public methods -

    func refreshModel() {
        dataProvider.updatePersonsModelsFromRemoteServer { (refreshModelResult) in
            self.isLoading = false
            switch refreshModelResult {
            case .failure(let error):
                self.alertMessage = error.localizedDescription
            case .success (let personModelControllers):
                self.personModelControllers = personModelControllers.sorted()
            }
        }
    }

    func personCellViewModel(for indexPath: IndexPath ) -> PersonCellViewModel? {
        guard indexPath.row < personModelControllers.count else {
            assertionFailure()
            return nil
        }

        return PersonCellViewModel(using: personModelControllers[indexPath.row])
    }

    func personDetailsViewModel(for indexPath: IndexPath) -> PersonDetailsViewModel? {
        guard indexPath.row < personModelControllers.count else {
            assertionFailure()
            return nil
        }

        return PersonDetailsViewModel(using: personModelControllers[indexPath.row])
    }
}

