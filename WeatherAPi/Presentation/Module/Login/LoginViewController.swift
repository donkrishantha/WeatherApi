//
//  LoginViewController.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 17/10/2024.
//

import UIKit
import SwiftUI

class LoginViewController: UIHostingController<LoginView> {
    
    init(viewModel: LoginViewModel) {
        super.init(rootView: LoginView(viewModel: viewModel))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init Corder: has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
