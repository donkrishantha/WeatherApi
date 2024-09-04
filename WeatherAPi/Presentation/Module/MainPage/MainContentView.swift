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
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        TabView {
            mainView
                .tabItem {
                    Label("Login", systemImage: "person.fill")
                }
            LoginView()
                .tabItem {
                    Label("Register", systemImage: "person.badge.plus")
                }
            LoginView()
                .tabItem {
                    Label("Feedback", systemImage: "bubble.left.fill")
                }
            LoginView()
                .tabItem {
                    Label("Subscribe", systemImage: "star.fill")
                }
        }
    }
    
    private var mainView: some View {
        return AnyView(
            NavigationView{
                ZStack{
                    BackgroundView()
                    VStack(alignment: .leading) {
                        SearchBar(searchText: $viewModel.searchText, placeholder: "Search..." )
                        
                        if viewModel.searchText.isEmpty {
                            /// History
                            //placesListView
                        } else {
                            /// Search results
                            //searchPlacesListView
                        }
    
                        self.detailView
    
                        Spacer()
    
                        .disableAutocorrection(true)
                    }
                    //.onAppear(perform: viewModel.loadAsyncData("dfdf"))
                    .alert(isPresented: $viewModel.showAlert) {
                        Alert(title: Text(viewModel.alertMessage?.title ?? "A/A"),
                              message: Text(viewModel.alertMessage?.message ?? "N/A"),
                              dismissButton: .default(Text("Got it!")))
                    }
                    .navigationTitle("Weather details")
                    .padding([.leading, .trailing], 15)
                }
            }
        )
    }
    
    private var detailView: some View {
        return AnyView(
            VStack(alignment: .leading) {
                Text(viewModel.weatherName)
                Text(viewModel.temperature)
                Text(viewModel.weatherDescription)
                Text(viewModel.observationDate)
                Text(viewModel.observationTime)
                if !viewModel.weatherIcon.isEmpty {
                    ImageView(imageUrl: viewModel.weatherIcon, size: 80)
                        .foregroundColor(.gray)
                }
                
                Button(viewModel.buttonTitle) {
                    viewModel.loadAsyncData(viewModel.searchText)
                }
                .disabled(viewModel.isRequestSendingDisabled)
                .foregroundColor(viewModel.isRequestSendingDisabled ? Color.gray : Color.blue)
                .font(.title)

            }.padding([.top], 20)
        )
    }
}

struct MainContentView_Preview: PreviewProvider {
    static var previews: some View {
        let networkManager = APIClient()
        let repo = WeatherApiRepoImplement(apiClient: networkManager)
        let viewModel: MainViewModel = MainViewModel(repository: repo)
        MainContentView(viewModel: viewModel)
    }
}