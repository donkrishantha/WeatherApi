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

/// Api request type
enum MainModelRequestType {
    case weatherDetail
    case tMDBDetails
    case postData
    case putData
    case patchData
}

final class MainViewModel: ObservableObject, Sendable {
    /// MARK: - Output
    @Published private(set) var weatherModel: WeatherModel?
    @Published private(set) var tMDBModel: TMDBModel?
    @Published private(set) var jsonPlaceHolderModel: JsonPlaceHolderModel?
    @Published private(set) var patchModel: PatchModel?
    @Published private(set) var isLoading: Bool = false
    @Published var alertMessage: AlertMessage?
    @Published var showAlert = false
    private let logger = Logger.dataStore
    var apiTask: Task<Void, Never>?
    
    /// MARK: - Input
    @Published var searchText: String = ""
    private(set) fileprivate var cancelable: Set<AnyCancellable> = []
    private var loadDataSubject = PassthroughSubject<Bool, ApiError2>()
    private var repository: (any WeatherApiRepoProtocol)? = nil
    private let weatherApiUseCaseProtocol: WeatherApiUseCaseProtocol?
    private(set) var isRequestSending = false
    
    var buttonTitle: String { isRequestSending ? "Sending..." : "Send" }
    var isRequestSendingDisabled: Bool { isRequestSending || searchText.isEmpty }
    
    /// MARK: - Initialisation
    init(weatherApiUseCaseProtocol: WeatherApiUseCaseProtocol) {
        self.weatherApiUseCaseProtocol = weatherApiUseCaseProtocol
        if !searchText.isEmpty {
            self.loadAsyncData(searchText)
        }
        self.searchLocation()
    }
    
    // MARK: - De-Initialisation
    deinit {
        print("DE INIT")
    }
    
    func disappear() {
        print("TASK_CANCEL")
        apiTask?.cancel()
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
        
        self.apiTask = Task(priority: .medium) {
            await getWeatherDetail(type: .weatherDetail, text: searchText)
            Task { @MainActor in // DispatchQueue.main.async {}
                self.searchText = ""
                isLoading = true
            }
            try? Task.checkCancellation()
        }
    }
    
    func getWeatherDetail(type: MainModelRequestType, text: String) async {
        loading()
        let parameters = WeatherDetailParams(searchTerm: text)
        let response: AnyPublisher<WeatherRowData, APIError>? = await weatherApiUseCaseProtocol?.execute(params: parameters)
        responseHandler(response: response, requestType: type)
    }
    
    func getTMDBDetailsWith(type: MainModelRequestType) async {
        loading()
        let response: AnyPublisher<TMDBModel, APIError>? = await weatherApiUseCaseProtocol?.execute(accountId: 11737776)
        responseHandler(response: response, requestType: type)
    }
    
    func getPostDataWith(type: MainModelRequestType) async {
        loading()
        let params: JsonPlaceHolderPostParams = JsonPlaceHolderPostParams(title: "Gayan Dias",
                                                                          body: "Gayan Body",
                                                                          userId: 812100297)
        let response: AnyPublisher<JsonPlaceHolderModel, APIError>? = await weatherApiUseCaseProtocol?.execute(params: params)
        responseHandler(response: response, requestType: type)
    }
    
    func getPutDataWith(type: MainModelRequestType) async {
        loading()
        let params: JsonPlaceHolderPostParams = JsonPlaceHolderPostParams(title: "Gayan Dias",
                                                                          body: "Saman Body",
                                                                          userId: 812100297)
        let response: AnyPublisher<JsonPlaceHolderModel, APIError>? = await weatherApiUseCaseProtocol?.execute2(params: params)
        responseHandler(response: response, requestType: type)
    }
    
    
    func getPatchDataWith(type: MainModelRequestType) async {
        loading()
        let response: AnyPublisher<PatchModel, APIError>? = await weatherApiUseCaseProtocol?.execute(title: "My personal")
        responseHandler(response: response, requestType: type)
    }
    
    private func loading() {
        guard !isLoading else { return }
        Task { @MainActor in isLoading = true }
        try? Task.checkCancellation()
    }
    
    /// Handel the response  in generally
    /// - Parameters:
    ///   - response: api response
    ///   - requestType: type of the response
    private func responseHandler<T: Codable>(response: AnyPublisher<T, APIError>?,
                         requestType: MainModelRequestType) {
        response?.sink { [weak self] completion in
            guard let self = self else { return }
            self.processErrorResponseWith(type: requestType, with: completion)
        } receiveValue: { [weak self] response in
            guard let self = self else { return }
            self.processSuccessResponseWith(type: requestType, and: response)
        }.store(in: &cancelable)
    }
}

// Handel request responses & errors
extension MainViewModel {
    
    /// Process error response  generally
    /// - Parameters:
    ///   - type: response  type
    ///   - completion: response model
    private func processErrorResponseWith(type: MainModelRequestType,
                                          with completion: Subscribers.Completion<APIError>){
        switch completion { case .finished: break; case .failure(let error):
            switch type {
            case .weatherDetail, .tMDBDetails, .postData, .putData, .patchData:
                defer { isLoading = false }
                DispatchQueue.main.async {
                    self.showAlert = true
                    self.alertMessage = AlertMessage(title: "Error!",
                                                     message: error.errorDescription ?? "N/A")
                }
            }
        }
    }
    
    
    /// Process success response  generally
    /// - Parameters:
    ///   - type: response  type
    ///   - response: response model
    private func processSuccessResponseWith<T: Codable>(type: MainModelRequestType,
                                                         and response: T) {
        //self.logger.info("SUCCESS:")
        defer { isLoading = false }
        switch type {
        case .weatherDetail:
            Task { @MainActor in // DispatchQueue.main.async {}
                guard let response = response as? WeatherModel else { return }
                self.weatherModel = response
            }
        case .tMDBDetails:
            Task { @MainActor in // DispatchQueue.main.async {}
                guard let response = response as? TMDBModel else { return }
                self.tMDBModel = response
            }
        case .postData:
            Task { @MainActor in // DispatchQueue.main.async {}
                guard let response = response as? JsonPlaceHolderModel else { return }
                self.jsonPlaceHolderModel = response
            }
        case .putData:
            Task { @MainActor in // DispatchQueue.main.async {}
                guard let response = response as? JsonPlaceHolderModel else { return }
                self.jsonPlaceHolderModel = response
            }
        case .patchData:
            Task { @MainActor in // DispatchQueue.main.async {}
                guard let response = response as? PatchModel else { return }
                self.patchModel = response
            }
        }
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
