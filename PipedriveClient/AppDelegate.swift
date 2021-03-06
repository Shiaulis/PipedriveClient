//
//  AppDelegate.swift
//  PipedriveClient
//
//  Created by Andrius Shiaulis on 19.08.2018.
//  Copyright © 2018 Andrius Shiaulis. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Properties -
    
    private let window: UIWindow
    private let applicationModel: ApplicationModel
    
    // MARK: - Initialization -
    
    override init() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.applicationModel = ApplicationModel()
    }
    
    // MARK: - AppDelegate callbacks -
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        applicationModel.setup()
        
        let viewModel = PersonsListViewModel(using: applicationModel)
        let rootViewController = PersonsListViewController(using: viewModel)
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        return true
    }
}
