//
//  AppCoordinator.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 16/01/2024.
//

import Foundation
import Network

protocol AppCoordinatorProtocol: AnyObject {
    func start()
}

final class AppCoordinatorImplement: AppCoordinatorProtocol {
    unowned private let navigationController: NavigationController
    
    init(navigationController: NavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let repo = WeatherApiRepoImplement(networkManager: NetworkManager())
        let networkMonitor = NetworkPathMonitor(monitor: NWPathMonitor())
        let viewModel: MainViewModel = MainViewModel(repository: repo, networkMonitor: networkMonitor)
        //let viewModel2: AppViewModel = AppViewModel(networkMonitor: networkMonitor)
        let viewController = MainViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: true)
    }
}
