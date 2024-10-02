//
//  UIKit.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 01/10/2024.
//

import UIKit

extension UIDevice {
    /// Checks if the current device that runs the app is xCode's simulator
    static func isSimulator() -> Bool {
        #if targetEnvironment(simulator)
            return true
        #else
            return false
        #endif
    }
}
