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
//            let viewModel1 = ImageUploadViewModel()
//            ImageUploadContentView(viewModel: viewModel1)
//                .tabItem {
//                    Label("Feedback", systemImage: "bubble.left.fill")
//                }
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
                    BackgroundView()
                    VStack(alignment: .leading) {
                        SearchBar(searchText: $viewModel.searchText, placeholder: "Search..." )
                        
                        //                        if viewModel.searchText.isEmpty {
                        //                            /// History
                        //                            //placesListView
                        //                        } else {
                        //                            /// Search results
                        //                            //searchPlacesListView
                        //                        }
                        
                        self.detailView
                        self.timerView
                        
                        Spacer()
                        
                            .disableAutocorrection(true)
                    }
                    //.onAppear(perform: viewModel.loadAsyncData("dfdf"))
                    .alert(isPresented: $viewModel.showAlert) {
                        Alert(title: Text(viewModel.alertMessage?.title ?? "A/A"),
                              message: Text(viewModel.alertMessage?.message ?? "N/A"),
                              //dismissButton: .default(Text("Ok")
                              primaryButton:.destructive(Text("Ok"), action: {
                            print("Deleting...")
                        }) , secondaryButton: .cancel()
                        )
                    }
                    .navigationTitle("Weather details")
                    .padding([.leading, .trailing], 15)
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
                Text("Description: " + (viewModel.weatherModel?.weatherDescription ?? "N/A"))
                Text("Temperature: " + (viewModel.weatherModel?.temperature ?? "N/A"))
                Text("Time: " + (viewModel.weatherModel?.observationTime ?? "N/A"))
                
//                if (((viewModel.weatherModel?.weatherIcon?.isEmpty) == nil)) {
//                    ImageView(imageUrl: viewModel.weatherIcon?.weatherIcon, size: 80)
//                        .foregroundColor(.gray)
//                }
                /*
                Button(viewModel.buttonTitle) {
                    viewModel.loadAsyncData(viewModel.searchText)
                    viewModel.showAlert = true
                    viewModel.alertMessage = AlertMessage(title: "Alert!", message: "Please enter search term.")
                }
                
                Button("Show 1") {
                    viewModel.showAlert = true
                    viewModel.alertMessage = AlertMessage(title: "Alert1", message: "Please enter search term.")
                }
                
                Button("Show 2") {
                    viewModel.showAlert = true
                    viewModel.alertMessage = AlertMessage(title: "Alert2", message: "Please enter search term.")
                }*/
                
                self.timerView
                    .disabled(viewModel.isRequestSendingDisabled)
                    .foregroundColor(viewModel.isRequestSendingDisabled ? Color.gray : Color.blue)
                    .font(.title)
                
            }.padding([.top], 20)
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
//struct MainContentView_Preview: PreviewProvider {
//    static var previews: some View {
//        let networkManager = APIClient()
//        let repo = WeatherApiRepoImplement(apiClient: networkManager)
//        let viewModel: MainViewModel = MainViewModel(repository: repo)
//        MainContentView(viewModel: viewModel)
//    }
//}
#endif

