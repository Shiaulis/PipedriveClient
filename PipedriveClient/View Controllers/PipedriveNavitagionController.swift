//
//  PipedriveNavitagionController.swift
//  PipedriveClient
//
//  Created by Andrius Shiaulis on 22.08.2018.
//  Copyright © 2018 Andrius Shiaulis. All rights reserved.
//

import UIKit

class PipedriveNavitagionController: UINavigationController {


    // MARK: - View controller life cycle -

    override func viewDidLoad() {
        setupView()
    }

    // MARK: - Private methods -

    private func setupView() {
        navigationBar.prefersLargeTitles = true
    }
}
