//
//  AppDelegate.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 16/01/2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication,
                     didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
}

/*
// https://www.themoviedb.org/settings/api
"API  KEY" = "e4ab5713fceabad51f2e877a77549e38"
"Access Token" = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlNGFiNTcxM2ZjZWFiYWQ1MWYyZTg3N2E3NzU0OWUzOCIsIm5iZiI6MTY0MTg5NzY4MC40MzM5OTk4LCJzdWIiOiI2MWRkNWVkMDFkNmM1ZjAwMWJmZjJmMTciLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.BF25FTUljDa81WHUsIdBvmpR_Y_1OuMf2D3PVeT9mgs"
*/
