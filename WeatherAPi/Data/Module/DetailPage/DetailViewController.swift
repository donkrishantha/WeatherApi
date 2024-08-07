//
//  DetailViewController.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 16/01/2024.
//

import UIKit
import SwiftUI

class DetailViewController: UIHostingController<DetailContentView> {

    init(viewModel: DetailViewModel) {
        super.init(rootView: DetailContentView(viewModel: viewModel))
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
