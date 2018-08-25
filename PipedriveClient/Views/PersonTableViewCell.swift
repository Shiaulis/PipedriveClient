//
//  PersonTableViewCell.swift
//  PipedriveClient
//
//  Created by Andrius Shiaulis on 22.08.2018.
//  Copyright © 2018 Andrius Shiaulis. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {

    // MARK: - Properties -

    var titleText: String? {
        didSet {
            titleLabel.text = titleText
        }
    }

    var subtitleText: String? {
        didSet {
            subtitleLabel.text = subtitleText
        }
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .black
        label.textAlignment = .natural
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .gray
        label.textAlignment = .natural
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initialization -

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Private methods -

    private func setupViews() {

        // Self-Sizing Table View Cells
        // https://developer.apple.com/documentation/uikit/uifont/creating_self_sizing_table_view_cells

        contentView.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        titleLabel.firstBaselineAnchor.constraintEqualToSystemSpacingBelow(contentView.layoutMarginsGuide.topAnchor, multiplier: 1).isActive = true

        contentView.addSubview(subtitleLabel)
        subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        contentView.layoutMarginsGuide.bottomAnchor.constraintEqualToSystemSpacingBelow(subtitleLabel.lastBaselineAnchor, multiplier: 1).isActive = true
        subtitleLabel.firstBaselineAnchor.constraintEqualToSystemSpacingBelow(titleLabel.lastBaselineAnchor, multiplier: 1).isActive = true

        contentView.addSubview(subtitleLabel)
    }
}
