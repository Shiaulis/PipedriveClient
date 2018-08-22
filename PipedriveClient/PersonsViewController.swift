//
//  PersonsViewController.swift
//  PipedriveClient
//
//  Created by Andrius Shiaulis on 19.08.2018.
//  Copyright © 2018 Andrius Shiaulis. All rights reserved.
//

import UIKit

class PersonsViewController: UITableViewController {

    // MARK: - Properties -

    private let dataProvider: DataProvider

    // MARK: - Initializaion -
    init(using dataProvider: DataProvider) {
        self.dataProvider = dataProvider
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View controller life cycle -

    override func viewDidLoad() {
        setupView()
    }

    // MARK: - Private methods -

    // MARK: Setup views

    private func setupView() {
        view.backgroundColor = .white
    }
}

