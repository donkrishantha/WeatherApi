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
    
    var progress: Float = 0.2
    
    var attributedText: AttributedString{
        
        var text = AttributedString("Please read the Privacy Policy and Terms and Condition")
        
        if let index = text.range(of:"Privacy Policy"){
            
            text[index].foregroundColor = .red
            text[index].underlineStyle = Text.LineStyle.single
        }
        
        if let index = text.range(of:"Terms and Condition"){
            
            text[index].foregroundColor = .red
            text[index].underlineStyle = Text.LineStyle.single
        }
        
        return text
    }
    
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
    
    private var LoadingStatus: some View {
        switch viewModel.phase {
        case .loading:
            ProgressView("Loading Profile...")
        case .loaded:
            //ProfileView(profile: profile)
            ProgressView("Loading Profile...")
        case .error(let message):
            //ErrorView(message: message)
            ProgressView("Loading Profile...")
        }
    }
    
    private var mainView: some View {
        return AnyView(
            NavigationView {
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
                .onAppear(perform: onAppear)
                .onDisappear(perform: onDisappear))
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
                        callTMDBDetails()
                    }) {
                        Text("TMDB: GET_REQUEST")
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.regular)
                    .unredacted()
                    Text(viewModel.tMDBModel?.username ?? "N/A")
                        .redacted(reason: viewModel.isLoading ? .placeholder : [])
                }
                LazyHStack(alignment: .firstTextBaseline) {
                    Button(action: {
                        callPostRequest()
                    }) {
                        Text("POST_REQUEST")
                    }
                    .disabled(viewModel.isLoading)
                    .buttonStyle(.borderedProminent)
                    //.controlSize(.regular)
                    .unredacted()
                    .frame(width: 200)
                    Text(viewModel.jsonPlaceHolderModel?.title ?? "N/A")
                        .redacted(reason: viewModel.isLoading ? .placeholder : .init())
                }
                LazyHStack(alignment: .firstTextBaseline) {
                    Button(action: {
                        callPutRequest()
                    }) {
                        Text("PUT_REQUEST")
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.regular)
                    .unredacted()
                    Text(String(viewModel.jsonPlaceHolderModel?.userId ?? 000))
                        .redacted(reason: viewModel.isLoading ? .placeholder : [])
                }
                LazyHStack(alignment: .firstTextBaseline) {
                    Button(action: {
                        callPatchRequest()
                    }) {
                        Text("PATCH_REQUEST")
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.regular)
                    .unredacted()
                    
                }
                HStack {
                    Button(action: {
                        viewModel.testFaceApi()
                    }) {
                        Text("TEST API REQUEST")
                        .lineLimit(1)
                        //.minimumScaleFactor(0.5)
                        //.minimumScaleFactor(viewModel.isLoading ? 0.5 : 0)
                        .padding([.leading, .trailing], viewModel.isLoading ? 10 : 0)
                        .offset(x : viewModel.isLoading ? -15 : 0)
                        .frame(width: 155)
                    }
                    .overlay(alignment: .trailing, content: {
                        CircularProgressView(isLoading: viewModel.isLoading)
                            .padding([.trailing, .leading], +8)
                    })
                    .disabled(viewModel.isLoading)
                    .buttonStyle(.borderedProminent)
                    .unredacted()
                    Text("\(viewModel.isLoading)")
                }
                Button {
                    viewModel.testFaceApi()
                } label: {
                }
                //---------------------------------
                VStack {
                    CircularProgressView(isLoading: viewModel.isLoading)
                    .frame(width: 30, height: 30)
                }
                /*Text("Hello World!")
                 .font(.title)
                 .foregroundColor(.red)
                 Text("Hello World!")
                 .font(.title)
                 .background(.red)
                 Text("Hello World!")
                 .font(.title)
                 .underline(true,color: .red)
                 Text("Hello World!")
                 .font(.title)
                 .strikethrough(true,color: .red)
                 Text("Hello\nHow are you?")
                 .font(.title)
                 .multilineTextAlignment(.center)
                 Text("Hello, World!")
                 .font(.title)
                 .blur(radius: 2)
                 Text(Date(), style: .date)
                 Text(attributedText)
                 .font(.title3)
                 Text(Date(),style: .date) // 4 October 2025
                 Text(Date(),style: .time) // 11:24 PM
                 Text(Date(),style: .relative) // This will show the count up timer like this: 1 min 25 sec)
                 Text(Date(),style: .timer) // This will show the count up timer like this: 1:15
                 Text(Date(),style: .offset) // This will show the count up timer like this: +1 minute
                 Text(verbatim: "Hello, \\(name)")
                 Text(122, format: .currency(code: "USD"))
                 .font(.largeTitle)
                 Text(122, format: .percent)
                 .font(.largeTitle)
                 Text("Hello Swift!")
                 .kerning(10)
                 Text("Hello Swift!")
                 .hidden()
                 Text("Hello Swift!")
                 .textSelection(.enabled)
                 Text("Hello Swift!")
                 .textSelection(.disabled)
                 Text("Hello SwiftUI")
                 .accessibilityLabel("Hello from SwiftUI")
                 /// When you hover over the button, a tooltip will appear as a hint.
                 Button("Delete") {
                 print("Deleted!")
                 }
                 .help("Deletes the item")
                 if #available(iOS 16.0, *) {
                 Text(timerInterval: Date.now...Date.now.addingTimeInterval(3600),
                 countsDown: true)
                 } else {
                 // Fallback on earlier versions
                 }*/
                /*
                 //https://unsplash.com/photos/yC-Yzbqy7PY
                 AsyncImageView(imageUrl: "https://hws.dev/img/logo.png",
                 placeHolder: "questionmark",
                 height: 44,
                 width: 44,
                 cornerRadius: 5,
                 shouldShowLoading: false)
                 .redacted(reason: viewModel.isLoading ? .placeholder : .init())
                 
                 Spacer()
                 self.timerView
                 .disabled(viewModel.isRequestSendingDisabled)
                 .foregroundColor(viewModel.isRequestSendingDisabled ? Color.gray : Color.blue)
                 .font(.title)*/
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
    
    private func callTMDBDetails() {
        viewModel.getTMDBDetailsWith(type: .tMDBDetails)
    }
    
    private func callPostRequest() {
        viewModel.getPostDataWith(type: .postData)
    }
    
    private func callPutRequest() {
        viewModel.getPutDataWith(type: .putData)
    }
    
    private func callPatchRequest() {
        viewModel.getPatchDataWith(type: .patchData)
    }
    
    private func onAppear() {
        print("ON_APPEAR")
    }
    
    private func onDisappear() {
        print("ON_DIAPPEAR")
        viewModel.disappear()
    }
}

extension View {
    /// Hide or show the view based on a boolean value.
    ///
    /// Example for visibility:
    ///
    ///     Text("Label")
    ///         .isHidden(true)
    ///
    /// Example for complete removal:
    ///
    ///     Text("Label")
    ///         .isHidden(true, remove: true)
    ///
    /// - Parameters:
    ///   - hidden: Set to `false` to show the view. Set to `true` to hide the view.
    ///   - remove: Boolean value indicating whether or not to remove the view.
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
            //self.opacity(hidden ? 0 : 1)
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
