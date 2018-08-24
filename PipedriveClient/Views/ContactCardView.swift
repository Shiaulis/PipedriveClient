//
//  ContactCardView.swift
//  PipedriveClient
//
//  Created by Andrius Shiaulis on 23.08.2018.
//  Copyright © 2018 Andrius Shiaulis. All rights reserved.
//

import UIKit

class ContactCardView: UIView {

    // MARK: - Properties -

    // MARK: Data
    private let viewModel: ContactCardViewModel

    // MARK: UI
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .gray
        label.textAlignment = .natural
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .black
        label.textAlignment = .natural
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()


    // MARK: - Initialization -

    init(using viewModel: ContactCardViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Private methods -

    private func setupViews() {
        descriptionLabel.text = viewModel.descriptionLabelText
        addSubview(descriptionLabel)
        descriptionLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        descriptionLabel.firstBaselineAnchor.constraintEqualToSystemSpacingBelow(layoutMarginsGuide.topAnchor, multiplier: 0.4).isActive = true

        valueLabel.text = viewModel.valueLabelText
        addSubview(valueLabel)
        valueLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor).isActive = true
        valueLabel.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor).isActive = true
        layoutMarginsGuide.bottomAnchor.constraintEqualToSystemSpacingBelow(valueLabel.lastBaselineAnchor, multiplier: 0.4).isActive = true
        valueLabel.firstBaselineAnchor.constraintEqualToSystemSpacingBelow(descriptionLabel.lastBaselineAnchor, multiplier: 1).isActive = true

        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
    }
}
