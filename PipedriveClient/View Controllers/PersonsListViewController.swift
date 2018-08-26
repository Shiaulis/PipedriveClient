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
    static private let cellID = "PersonsListViewControllerCellID"

    private let viewModel: PersonsListViewModel

    // MARK: - Initializaion -

    init(using viewModel: PersonsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View controller life cycle -

    override func viewDidLoad() {
        setupViewModel()
        setupView()
        setupNavigationBar()
        setupTableView()
    }

    // MARK: - Table view data source methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PersonsListViewController.cellID, for: indexPath) as? PersonTableViewCell else {
            assertionFailure()
            return UITableViewCell()
        }

        guard let cellViewModel = viewModel.personCellViewModel(for: indexPath) else {
            assertionFailure()
            return UITableViewCell()
        }

        cell.titleText = cellViewModel.titleLabelText
        cell.subtitleText = cellViewModel.subtitleLabelText

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let personDetailsViewModel = viewModel.personDetailsViewModel(for: indexPath) else {
            assertionFailure()
            return
        }

        let personDetailsViewController = PersonDetailsViewController(using: personDetailsViewModel)
        navigationController?.pushViewController(personDetailsViewController, animated: true)
    }

    // MARK: - Private methods -

    private func presentPlaceholderViewIfNeeded() {
        let shouldPresentPlaceholder = viewModel.shouldPresentPlaceholder ?? false
        if shouldPresentPlaceholder {
            tableView.backgroundView = PlaceholderView()
        }
        else {
            tableView.backgroundView = nil
        }
    }

    private func setupViewModel() {
        viewModel.showAlertBlock = { [weak self] in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert( message )
                }
            }
        }

        viewModel.updateLoadingStatus = { [weak self] in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.tableView.refreshControl?.beginRefreshing()
                }
                else {
                    self?.tableView.refreshControl?.endRefreshing()
                }
            }
        }

        viewModel.updatePlaceholderViewStatusBlock = { [weak self] in
            DispatchQueue.main.async {
                self?.presentPlaceholderViewIfNeeded()
            }

        }

        viewModel.reloadTableViewBlock = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    // MARK: Setup views

    private func setupView() {
        view.backgroundColor = .white
    }

    private func setupNavigationBar() {
        navigationItem.title = PersonsListViewController.controllerTitle
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupTableView() {
        tableView.register(PersonTableViewCell.self, forCellReuseIdentifier: PersonsListViewController.cellID)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControllPulledAction), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.tableFooterView = UIView()
        presentPlaceholderViewIfNeeded()
    }

    // MARK: Targeted actions

    @objc func refreshControllPulledAction() {
        viewModel.refreshModel()
    }

    // MARK: -

    private func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
