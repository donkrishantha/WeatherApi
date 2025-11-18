//
//  MainContentView.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 16/01/2024.
//

import SwiftUI
import Network
//import Module2

struct MainContentView: View {
    
    @ObservedObject private var viewModel: MainViewModel
    //@StateObject private var viewModel: MainViewModel
    
    /// Image picker property
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker: Bool = false
    @State private var showAlert2: Bool = false
    /// -------------
    @State private var showingAlert1 = false
    @State private var showingAlert2 = false
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        TabView {
            mainView
                .tabItem {
                    Label("Login", systemImage: "person.fill")
                }
            let viewModel = LoginViewModel()
            LoginView(viewModel: viewModel)
                .tabItem {
                    Label("Register", systemImage: "person.badge.plus")
                }
            let repository = WeatherApiRepoImplement(apiClient: APIClient())
            let viewM = DetailViewModel(repository: repository)
            DetailContentView(viewModel: viewM)
                .tabItem {
                    Label("Subscribe", systemImage: "star.fill")
                }
        }
    }
    
    private var mainView: some View {
        return AnyView(
            NavigationView{
                ZStack{
                    ScrollView {
                        BackgroundView()
                        VStack(alignment: .leading) {
                            SearchBars(searchText: $viewModel.searchText, placeholder: "Search..." )
                            //SearchBar(searchText: viewModel.searchText , placeholder: "Search...")
                            self.detailView
                            self.timerView
                            Spacer()
                                .disableAutocorrection(true)
                        }
                        .alert(isPresented: $viewModel.showAlert) {
                            Alert(title: Text(viewModel.alertMessage?.title ?? "A/A"),
                                  message: Text(viewModel.alertMessage?.message ?? "N/A"),
                                  primaryButton:.destructive(Text("Ok"), action: {
                                print("Deleting...")
                            }) , secondaryButton: .cancel()
                            )
                        }
                        .navigationTitle("Weather details")
                        .padding([.leading, .trailing], 15)
                    }
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(selectedImage: $selectedImage, isPresented: $showImagePicker)
                }
            }
        )
    }
    
    
    private var detailView: some View {
        return AnyView(
            VStack(alignment: .leading) {
                LazyHStack(alignment: .firstTextBaseline) {
                    Text("Description: ")
                        .unredacted()
                    Text(viewModel.weatherModel?.weatherDescription ?? "N/A")
                        .redacted(reason: viewModel.isLoading ? .placeholder : [])
                    }
                LazyHStack(alignment: .firstTextBaseline) {
                    Text("Temperature: ")
                        .unredacted()
                    Text(viewModel.weatherModel?.temperature ?? "N/A")
                        .redacted(reason: viewModel.isLoading ? .placeholder : [])
                }
                LazyHStack(alignment: .firstTextBaseline) {
                    Text("Time: ")
                        .unredacted()
                    Text(viewModel.weatherModel?.observationTime ?? "N/A")
                        .redacted(reason: viewModel.isLoading ? .placeholder : [])
                }

                LazyHStack(alignment: .firstTextBaseline) {
                    Button(action: {
                        self.viewModel.callTMDBDetail()
                    }) {
                        Text("TMDB: GET_REQUEST")
                    }
                    .unredacted()
                    Text(viewModel.tMDBModel?.username ?? "N/A")
                        .redacted(reason: viewModel.isLoading ? .placeholder : [])
                }
                LazyHStack(alignment: .firstTextBaseline) {
                    Button(action: {
                        self.viewModel.callJsonPlaceHolderPostRequestMethod()
                    }) {
                        Text("POST_REQUEST")
                    }
                    .unredacted()
                    Text(viewModel.jsonPlaceHolderModel?.title ?? "N/A")
                        .redacted(reason: viewModel.isLoading ? .placeholder : .init())
                }
                LazyHStack(alignment: .firstTextBaseline) {
                    Button(action: {
                        self.viewModel.callJsonPlaceHolderPutRequestMethod()
                    }) {
                        Text("PUT_REQUEST")
                    }
                    .unredacted()
                    Text(String(viewModel.jsonPlaceHolderModel?.userId ?? 000))
                        .redacted(reason: viewModel.isLoading ? .placeholder : [])
                }
                LazyHStack(alignment: .firstTextBaseline) {
                    Button(action: {
                        self.viewModel.callJsonPlaceHolderPatchRequestMethod()
                    }) {
                        Text("PATCH_REQUEST")
                    }
                    .unredacted()
                    
                }
                LazyHStack(alignment: .firstTextBaseline) {
//                    SwiftUIButtonView{
//                        print("Test Module Buton")
//                    }
                }
                
                    //https://unsplash.com/photos/yC-Yzbqy7PY
//                    AsyncImageView(imageUrl: "https://hws.dev/img/logo.png",
//                                   placeHolder: "questionmark",
//                                   height: 44,
//                                   width: 44,
//                                   cornerRadius: 5,
//                                   shouldShowLoading: false)
//                    .redacted(reason: viewModel.isLoading ? .placeholder : .init())
                    
//                Spacer()
//                self.timerView
//                    .disabled(viewModel.isRequestSendingDisabled)
//                    .foregroundColor(viewModel.isRequestSendingDisabled ? Color.gray : Color.blue)
//                    .font(.title)
                
            }.padding([.top], 20)
             //.redacted(reason: .placeholder)
        )
    }
    
    private var timerView: some View {
        
        @State var countDownTimer = 5
        @State var timerRunning = false
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        
        return AnyView {
            VStack {
                Text("\(countDownTimer)")
                    .onReceive(timer) { _ in
                        if countDownTimer > 0 && timerRunning {
                            countDownTimer -= 1
                        } else {
                            timerRunning = false
                        }
                    }
                    .font(.system(size: 80, weight: .bold))
                    .opacity(0.08)
                
                HStack(spacing: 30) {
                    Button("Start") {
                        timerRunning = true
                    }
                    
                    Button("Reset") {
                        countDownTimer = 10
                    }.foregroundColor(.red)
                }
            }
        }
    }
}

#if DEBUG
struct MainContentView_Preview: PreviewProvider {
    static var previews: some View {
        let networkManager = APIClient()
        let repo = WeatherApiRepoImplement(apiClient: networkManager)
        let viewModel: MainViewModel = MainViewModel(weatherApiUseCaseProtocol: repo as! WeatherApiUseCaseProtocol)
        MainContentView(viewModel: viewModel)
    }
}
#endif

