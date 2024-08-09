//
//  MainContentView.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 16/01/2024.
//

import SwiftUI
import Network

struct MainContentView: View {
    @ObservedObject private var viewModel: MainViewModel
    @State private var searchTerm: String = ""
    @State var counter = 0
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView{
            VStack(alignment: .leading, spacing: 10) {
                SearchBar(searchText: $viewModel.searchText, placeholder: "Search..." )
                    .padding()
                
                Group{
                    Text(viewModel.weatherName)
                    Text(viewModel.temperature)
                    Text(viewModel.weatherDescription)
                    Text(viewModel.observationDate)
                    Text(viewModel.observationTime)
                }.font(.title)
                if !viewModel.weatherIcon.isEmpty {
                    ImageView(imageUrl: viewModel.weatherIcon, size: 80)
                }
                TextField("Search...",
                    text: $searchTerm
                )
                Button(action: {
                    viewModel.loadAsyncData()
                }, label: {
                    Text("Press me")
                        .padding(20)
                })
                .frame(width: 200, height: 50)
                .disableAutocorrection(true)
                .padding([.leading], 0)
            }
            .onAppear(
                perform: viewModel.loadAsyncData
            )
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text(viewModel.alertMessage?.title ?? "A/A"),
                      message: Text(viewModel.alertMessage?.message ?? "N/A"),
                      dismissButton: .default(Text("Got it!")))
            }
            .navigationTitle("Weather details")
            .padding([.leading], 15)
        }
    }
}

struct MainContentView_Preview: PreviewProvider {
    static var previews: some View {
        let networkManager = NetworkManager()
        let repo = WeatherApiRepoImplement(networkManager: networkManager)
        let viewModel: MainViewModel = MainViewModel(repository: repo)
        MainContentView(viewModel: viewModel)
    }
}
