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
        NavigationView{
            ZStack(alignment: .topLeading){
                VStack(alignment: .leading) {
                    Text("BASE_URL: \(Environment.baseUrl)")
                    Text("\(Environment.apiKy)")
                }
            }
            .navigationTitle("Environment Details")
        }
    }
}

struct DetailContentView_Preview: PreviewProvider {
    static var previews: some View {
        let dependencyContainer = DependencyContainer()
        let repository: any WeatherApiRepoProtocol = dependencyContainer.weatherApiRepository
        let viewModel: DetailViewModel = DetailViewModel(repository: repository as! WeatherApiRepoImplement)
        DetailContentView(viewModel: viewModel)
    }
}
