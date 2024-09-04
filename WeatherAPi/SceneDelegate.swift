//
//  SceneDelegate.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 16/01/2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        if let windowScene = scene as? UIWindowScene {
            window = setUpWindow(in: windowScene)
        }
    }
    
    private func setUpWindow(in scene: UIWindowScene) -> UIWindow {
        let dependencyContainer = DependencyContainer()
        let navigationController = NavigationController()
        
        let window = UIWindow(windowScene: scene)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        let coordinator = AppCoordinatorImplement(dependencyContainer: dependencyContainer,
                                                  navigationController: navigationController)
        coordinator.start()
        
        return window
    }
}

