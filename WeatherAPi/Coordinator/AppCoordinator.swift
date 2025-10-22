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
    
    private let dependencyContainer: DependencyContainer
    unowned private let navigationController: NavigationController
    
    init(dependencyContainer: DependencyContainer, navigationController: NavigationController) {
        self.navigationController = navigationController
        self.dependencyContainer = dependencyContainer
    }
    
    func start() {
//        let viewModel: MainViewModel = MainViewModel(repository: dependencyContainer.weatherApiRepository)
//        let viewController = MainViewController(viewModel: viewModel)
//        navigationController.setViewControllers([viewController], animated: true)
        
        let viewModel: MainViewModel = MainViewModel(weatherApiUseCaseProtocol: dependencyContainer.weatherApiUseCaseProtocol)
        let viewController = MainViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: true)
    }
}
