//
//  NavigationController.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 16/01/2024.
//

import UIKit

class NavigationController: UINavigationController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
