//
//  PersonDetailsViewController.swift
//  PipedriveClient
//
//  Created by Andrius Shiaulis on 23.08.2018.
//  Copyright © 2018 Andrius Shiaulis. All rights reserved.
//

import UIKit

class PersonDetailsViewController: UIViewController {

    // MARK: - Properties -

    // This offset is used to align all UI from leading and trailing borders on the same distance
    private static let offset: CGFloat = 24.0

    // MARK: Data
    private let viewModel: PersonDetailsViewModel

    // MARK: UI

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9764705882, blue: 1, alpha: 1)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    // We put all scrollable content in this view
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9764705882, blue: 1, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let personImageView: UIImageView = {
        let imaveView = UIImageView.init(image: #imageLiteral(resourceName: "PersonIcon"))
        imaveView.contentMode = .scaleAspectFit
        imaveView.translatesAutoresizingMaskIntoConstraints = false
        return imaveView
    }()

    private let personNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 2
        label.minimumScaleFactor = 0.8
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var organizationNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var contactDetailsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .gray
        label.textAlignment = .natural
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.2
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initialization -

    init(using viewModel: PersonDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View controller life cycle -

    override func viewDidLoad() {
        setupViews()
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = viewModel.personNameLabelText
        navigationItem.title = NSLocalizedString("Contact Details", comment: "details screen title")
    }

    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        scrollView.addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true

        containerView.addSubview(personImageView)
        personImageView.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
        personImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        personImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        personImageView.widthAnchor.constraint(equalTo: personImageView.heightAnchor).isActive = true

        personNameLabel.text = viewModel.personNameLabelText
        containerView.addSubview(personNameLabel)
        personNameLabel.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor, constant: 32).isActive = true
        personNameLabel.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor, constant: -32).isActive = true
        personNameLabel.topAnchor.constraint(equalTo: personImageView.bottomAnchor, constant: 8).isActive = true

        // Bottom view is used to show the lowest view
        // which is used for creating proper constraint
        var lowestView: UIView = personNameLabel

        organizationNameLabel.text = viewModel.organizationNameLabelText
        containerView.addSubview(organizationNameLabel)
        organizationNameLabel.leadingAnchor.constraint(equalTo: personNameLabel.leadingAnchor).isActive = true
        organizationNameLabel.trailingAnchor.constraint(equalTo: personNameLabel.trailingAnchor).isActive = true
        organizationNameLabel.topAnchor.constraint(equalTo: personNameLabel.bottomAnchor, constant: 8).isActive = true
        lowestView = organizationNameLabel

        if viewModel.shouldPresentContactsSection {

            addSeparator(lowestView: &lowestView, distanceFromLowestView: 24)

            contactDetailsLabel.text = NSLocalizedString("CONTACT DETAILS", comment: "label for contacts section in details view")
            containerView.addSubview(contactDetailsLabel)
            contactDetailsLabel.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor, constant: PersonDetailsViewController.offset).isActive = true
            contactDetailsLabel.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor, constant: -PersonDetailsViewController.offset).isActive = true
            contactDetailsLabel.topAnchor.constraint(equalTo: lowestView.bottomAnchor, constant: 8).isActive = true
            lowestView = contactDetailsLabel

            for contactCardViewModel in viewModel.contactCardViewModels {
                let contactCardView = ContactCardView(using: contactCardViewModel)

                containerView.addSubview(contactCardView)
                contactCardView.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor,
                                                             constant: PersonDetailsViewController.offset).isActive = true
                contactCardView.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor,
                                                              constant: -PersonDetailsViewController.offset).isActive = true
                contactCardView.topAnchor.constraint(equalTo: lowestView.bottomAnchor, constant: 8).isActive = true
                lowestView = contactCardView
            }


        }

        lowestView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8).isActive = true
    }

    private func addSeparator(lowestView: inout UIView, distanceFromLowestView: CGFloat) {
        let lineView = UIView.init(frame: .zero)
        lineView.backgroundColor = .gray
        lineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(lineView)
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lineView.topAnchor.constraint(equalTo: lowestView.bottomAnchor, constant: distanceFromLowestView).isActive = true
        lineView.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor, constant: PersonDetailsViewController.offset).isActive = true
        lineView.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor, constant: -PersonDetailsViewController.offset).isActive = true
        lowestView = lineView
    }
}
