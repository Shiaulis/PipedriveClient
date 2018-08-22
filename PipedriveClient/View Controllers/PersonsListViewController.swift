//
//  PersonsViewController.swift
//  PipedriveClient
//
//  Created by Andrius Shiaulis on 19.08.2018.
//  Copyright © 2018 Andrius Shiaulis. All rights reserved.
//

import UIKit

class PersonsListViewController: UITableViewController {

    // MARK: - Properties -

    static private let controllerTitle = NSLocalizedString("Contacts", comment: "controller title")

    private let viewModel: PersonsListViewModel

    // MARK: - Initializaion -

    init(using viewModel: PersonsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View controller life cycle -

    override func viewDidLoad() {
        setupView()
        setupNavigationBar()
        setupTableView()
    }

    // MARK: - Table view data source methods



    // MARK: - Private methods -

    // MARK: Setup views

    private func setupView() {
        view.backgroundColor = .white
    }

    private func setupNavigationBar() {
        navigationItem.title = PersonsListViewController.controllerTitle
    }

    private func setupTableView() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControllPulledAction), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    // MARK: - Targeted actions -

    @objc func refreshControllPulledAction() {
    }
}

