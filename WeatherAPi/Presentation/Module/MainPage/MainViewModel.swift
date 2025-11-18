//
//  MainViewModel.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 16/01/2024.
//

import Foundation
import Combine
import OSLog
import UIKit
import Network

enum AsyncErrors: Error {
    case dataNotAvailable
    case dataExist
}

enum MainViewModelError: Error {
    case networkError
    case dataParsingError
}

final class MainViewModel: ObservableObject {
    
    /// MARK: - Output
    @Published private(set) var weatherModel: WeatherModel?
    @Published private(set) var tMDBModel: TMDBModel?
    @Published private(set) var jsonPlaceHolderModel: JsonPlaceHolderModel?
    @Published var alertMessage: AlertMessage?
    @Published var showAlert = false
    @Published private(set) var isLoading: Bool = false
    private let logger = Logger.dataStore
    
    /// MARK: - Input
    @Published var searchText: String = ""
    private(set) fileprivate var cancelable: Set<AnyCancellable> = []
    private var loadDataSubject = PassthroughSubject<Bool, ApiError2>()
    private var repository: (any WeatherApiRepoProtocol)? = nil
    //@Injected var repository: (any WeatherApiRepoProtocol)?
    private let weatherApiUseCaseProtocol: WeatherApiUseCaseProtocol?
    private(set) var isRequestSending = false
    
    var buttonTitle: String { isRequestSending ? "Sending..." : "Send" }
    var isRequestSendingDisabled: Bool { isRequestSending || searchText.isEmpty }
    
    
    /// MARK: - Initialisation
    init(weatherApiUseCaseProtocol: WeatherApiUseCaseProtocol) {
        //init(repository: WeatherApiRepoProtocol = MockWeatherRepository()) {
        self.weatherApiUseCaseProtocol = weatherApiUseCaseProtocol
        if !searchText.isEmpty {
            self.loadAsyncData(searchText)
        }
        self.searchLocation()
        self.testMacro()
    }
    
    func testMacro() {
        //#if DEBUG
        
        #if PRODCUTION
        print("-----PRODUCTION")
        #elseif STAGING
        print("------STAGING")
        #elseif TEST
        print("-----TEST")
        #endif
    }
    
    // MARK: - De-Initialisation
    deinit {
        print("DE INIT")
    }
}

extension MainViewModel {
    
    /// search places in text field
    func searchLocation() {
        $searchText
            .dropFirst()
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue(label: "placesSearch", qos: .userInteractive))
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: self.loadAsyncData)
            .store(in: &cancelable)
    }
    
    /// request data async way
    func loadAsyncData(_ searchText: String) {
        guard !searchText.isEmpty else { return }
        
        isRequestSending = true
        
        Task (priority: .medium) {
            await getWeatherDetail(searchText)
            //self.loadLocalJsonData()
            DispatchQueue.main.sync {
                self.searchText = ""
            }
            isRequestSending = false
        }
    }
    
    func getWeatherDetail(_ text: String) async {
        /// request parameters
        let requestParameters = WeatherDetailParams(searchTerm: text)
        
        /// validate repository
        /*
        guard repository != nil else {
            self.showAlert = true
            self.alertMessage = AlertMessage(title: "Error!", message: "Missing service")
            return
        }*/
        #if DEBUG
        logger.trace("REQUEST: /current")
        #endif
        
        /// request to get "weather details"
        //let searchWeatherData = await self.repository?.searchWeatherData(params: requestParameters) as? AnyPublisher<WeatherRowData, ApiError>
        let searchWeatherData = await self.weatherApiUseCaseProtocol?.execute(params: requestParameters)
        searchWeatherData?
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.processErrorResponse(completion: completion)
            } receiveValue: { [weak self] rowWeatherResponse in
                guard let self = self else { return }
                self.processSuccessResponse(rowWeatherResponse: rowWeatherResponse.currentWeather)
            }.store(in: &cancelable)
        return
    }
    
    func callTMDBDetail() {
        self.isLoading = true
        Task (priority: .medium) {
            await self.getTMDBDetails()
        }
    }
    
    func getTMDBDetails() async {
        let tmdbData = await self.weatherApiUseCaseProtocol?.execute(accountId: 11737776)
        tmdbData?.sink { [weak self] completion in
                guard let self = self else { return }
                self.processErrorResponse(completion: completion)
            } receiveValue: { [weak self] tmdbResponse in
                guard self != nil else { return }
                self?.tMDBModel = tmdbResponse
                self?.isLoading = false
            }.store(in: &cancelable)
    }
    
    func callJsonPlaceHolderPostRequestMethod() {
        self.isLoading = true
        Task(priority: .medium) {
            await self.getPostData()
        }
    }
    
    func getPostData() async {
        let params: JsonPlaceHolderPostParams = JsonPlaceHolderPostParams(title: "Gayan Dias",
                                                                          body: "Gayan Body",
                                                                          userId: 812100297)
        let jsonPlaceHolderPostRequst = await self.weatherApiUseCaseProtocol?.execute(params: params)
        jsonPlaceHolderPostRequst?.sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                self.processErrorResponse(completion: completion)
            } receiveValue: { [weak self] jsonPlaceHolderResponse in
                guard self != nil else { return }
                self?.jsonPlaceHolderModel = jsonPlaceHolderResponse
                print(self?.jsonPlaceHolderModel?.title ?? "N/A")
                self?.isLoading = false
            }.store(in: &cancelable)
    }
    
    func callJsonPlaceHolderPutRequestMethod() {
        self.isLoading = true
        Task(priority: .medium) {
            await self.getPutData()
        }
    }
    
    func getPutData() async {
        let params: JsonPlaceHolderPostParams = JsonPlaceHolderPostParams(title: "Gayan Dias",
                                                                          body: "Gayan Body",
                                                                          userId: 812100297)
        let jsonPlaceHolderPostRequst = await self.weatherApiUseCaseProtocol?.execute2(params: params)
        jsonPlaceHolderPostRequst?.sink { [weak self] completion in
                guard let self = self else { return }
                self.processErrorResponse(completion: completion)
            } receiveValue: { [weak self] jsonPlaceHolderResponse in
                guard self != nil else { return }
                self?.jsonPlaceHolderModel = jsonPlaceHolderResponse
                print(self?.jsonPlaceHolderModel?.body ?? "N/A")
                self?.isLoading = false
            }.store(in: &cancelable)
    }
    
    func callJsonPlaceHolderPatchRequestMethod() {
        self.isLoading = true
        Task(priority: .medium) {
            await self.getPatchData()
        }
    }
    
    func getPatchData() async {
        let jsonPlaceHolderPostRequst = await self.weatherApiUseCaseProtocol?.execute(title: "My personal")
        jsonPlaceHolderPostRequst?.sink { [weak self] completion in
                guard let self = self else { return }
                self.processErrorResponse(completion: completion)
            } receiveValue: { [weak self] jsonPlaceHolderResponse in
                guard self != nil else { return }
                let response = jsonPlaceHolderResponse
                print(response)
                self?.isLoading = false
            }.store(in: &cancelable)
    }
    
    /// process error in further
    private func processErrorResponse(completion: Subscribers.Completion<APIError>) {
        switch completion { case .finished: break; case .failure(let error):
            logger.error("ERROR : \(error)")
            self.isLoading = false
            DispatchQueue.main.async {
                self.showAlert = true
                self.alertMessage = AlertMessage(title: "Error!", message: error.errorDescription ?? "N/A")
            }
        }
    }
    
    /// process response in further
    private func processSuccessResponse(rowWeatherResponse: CurrentWeather) {
        #if DEBUG
        self.logger.info("SUCCESS:")
        #endif
        self.isLoading = false
        //self.weatherModel = WeatherModel(data: rowWeatherResponse)
        let response = WeatherModel(data: rowWeatherResponse)
        self.weatherModel = response
    }
}

extension MainViewModel {
    
    /// load local json data
    fileprivate func loadLocalJsonData() {
        guard let data = FileLoader.readLocalFile("mock_weather_data") else {
            fatalError("Unable to locate file \"weatherData.json\" in main bundle.")
        }
        let rawWeather = FileLoader.loadJson(data)
        #if DEBUG
        self.logger.debug("Local database")
        #endif
        self.weatherModel = WeatherModel(data: rawWeather.currentWeather)
    }
}

/// request parameters
struct WeatherDetailParams {
    let searchTerm: String
    
    init(searchTerm: String) {
        self.searchTerm = searchTerm
    }
}

/// Observable pattern design test logic here.
class WeatherApp: ObserverProtocol {
    func moderate(temp: Double, humidity: Double, pressure: Double) {
        print("MainViewModel: temp \(temp) humidity \(humidity) pressure \(pressure)")
    }
    
    func update(temp: Double, humidity: Double, pressure: Double) {
        print("MainViewModel: temp \(temp) humidity \(humidity) pressure \(pressure)")
    }
}

struct JsonPlaceHolderPostParams: Encodable {
    let title: String
    let body: String
    let userId: Int
    
    init(title: String, body: String, userId: Int) {
        self.title = title
        self.body = body
        self.userId = userId
    }
}
