//
//  DetailContentView.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 16/01/2024.
//

import SwiftUI

struct DetailContentView: View {
    
    @ObservedObject private var viewModel: DetailViewModel
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct DetailContentView_Preview: PreviewProvider {
    static var previews: some View {
        //var session: URLSession
        let networkManager = APIClient()
        let repo = WeatherApiRepoImplement(apiClient: networkManager)
        let naviController = NavigationController()
        let coordinator = AppCoordinatorImplement(navigationController: naviController)
        let viewModel: DetailViewModel = DetailViewModel(repository: repo, coordinator: coordinator)
        DetailContentView(viewModel: viewModel)
    }
}
