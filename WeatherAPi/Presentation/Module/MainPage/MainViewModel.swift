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

//Dashboard status
enum DashboardPhase {
    case loading
    case content
    case empty
    case error
}

// Status
enum ProfilePhase {
    case loading
    case loaded
    case error(String)
}

/// Api request type
enum MainModelRequestType {
    case weatherDetail
    case tMDBDetails
    case postData
    case putData
    case patchData
}

final class MainViewModel: ObservableObject {
    // loading status
    @Published var phase: ProfilePhase = .loading
    
    
    // MARK: - Output
    @Published private(set) var weatherModel: WeatherModel?
    @Published private(set) var tMDBModel: TMDBModel?
    @Published private(set) var jsonPlaceHolderModel: JsonPlaceHolderModel?
    @Published private(set) var patchModel: PatchModel?
    @Published var isLoading: Bool = false
    @Published var alertMessage: AlertMessage?
    @Published var showAlert = false
    private let logger = Logger.dataStore
    private var apiTask: Task<Void, Never>?
    private var taskPriority: TaskPriority = .background
    
    // MARK: - Input
    @Published var searchText: String = ""
    private(set) fileprivate var cancelable: Set<AnyCancellable> = []
    private var loadDataSubject = PassthroughSubject<Bool, ApiError2>()
    private var repository: (any WeatherApiRepoProtocol)? = nil
    private let weatherApiUseCaseProtocol: WeatherApiUseCaseProtocol?
    private(set) var isRequestSending = false
    
    var buttonTitle: String { isRequestSending ? "Sending..." : "Send" }
    var isRequestSendingDisabled: Bool { isRequestSending || searchText.isEmpty }
    
    // MARK: - Initialisation
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
        checkCancellation()
    }
    
    // MARK: - Cancel tanks when View is dissipated.
    func disappear() {
        print("TASK_CANCEL")
        checkCancellation()
    }
    
    func testFaceApi() {
        //apiTask?.cancel()
        //print("before - isLoading: \(isLoading), isMainThread: \(Thread.isMainThread)")
        //guard apiTask == nil else { return }
        //loading()
        isLoading = true
        print("after - isLoading: \(isLoading), isMainThread: \(Thread.isMainThread)")
        apiTask = Task(priority: taskPriority) { [weak self] in
            await fakeApiCall()
        }
    }

    func fakeApiCall() async {
        for i in 1...2 {
            print("loop: \(i), isLoading: \(isLoading), isMainThread: \(Thread.isMainThread)")
            sleep(1)
            try? Task.checkCancellation()
            await Task.yield()
//            Task { @MainActor in
//                isLoading = true
//            }
        }
        await MainActor.run {
            isLoading = false
            //defer { isLoading = false }
            print("isLoading: \(isLoading), isMainThread: \(Thread.isMainThread)")
        }
    }
    
    private func performWork() async {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
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
        
        apiTask = Task(priority: taskPriority) {
            await getWeatherDetail(type: .weatherDetail, text: searchText)
            Task { @MainActor in // DispatchQueue.main.async {}
                self.searchText = ""
                isLoading = true
            }
            try? Task.checkCancellation()
        }
    }
    
    /// Api request for retrieve the weather details
    /// - Parameters:
    ///   - type: request type for handel generic function
    ///   - text: search text
    func getWeatherDetail(type: MainModelRequestType, text: String) async {
        loading()
        checkCancellation()

        apiTask = Task(priority: taskPriority) { [weak self] in
            guard let self = self else { return }
            let parameters = WeatherDetailParams(searchTerm: text)
            let response: AnyPublisher<WeatherRowData, APIError>? = await weatherApiUseCaseProtocol?.execute(params: parameters)
            await responseHandler(response: response, requestType: type)
        }
    }
    
    
    /// Api request for retrieve for weather details
    /// - Parameter type: request type for handel generic function
    func getTMDBDetailsWith(type: MainModelRequestType) {
        loading()
        checkCancellation()

        apiTask = Task(priority: taskPriority) { [weak self] in
            guard let self = self else { return }
            let response: AnyPublisher<TMDBModel, APIError>? = await weatherApiUseCaseProtocol?.execute(accountId: 11737776)
            await responseHandler(response: response, requestType: type)
        }
    }
    
    /// Api request for retrieve for post api details
    /// - Parameter type: request type for handel generic function
    func getPostDataWith(type: MainModelRequestType) {
        loading()
        checkCancellation()

        apiTask = Task(priority: taskPriority) { [weak self] in
            guard let self = self else { return }
            let params: JsonPlaceHolderPostParams =
            JsonPlaceHolderPostParams(title: "Gayan Dias",body: "Gayan Body",userId: 812100297)
            let response: AnyPublisher<JsonPlaceHolderModel, APIError>? = await weatherApiUseCaseProtocol?.execute(params: params)
            await responseHandler(response: response, requestType: type)
        }
    }
    
    /// Api request for retrieve for put api request details
    /// - Parameter type: request type for handel generic function
    func getPutDataWith(type: MainModelRequestType) {
        loading()
        checkCancellation()

        apiTask = Task(priority: taskPriority) { [weak self] in
            guard let self = self else { return }
            let params: JsonPlaceHolderPostParams =
            JsonPlaceHolderPostParams(title: "Gayan Dias",body: "Saman Body",userId: 812100297)
            let response: AnyPublisher<JsonPlaceHolderModel, APIError>? = await weatherApiUseCaseProtocol?.execute2(params: params)
            await responseHandler(response: response, requestType: type)
        }
    }
    
    /// Api request for retrieve for patch api details
    /// - Parameter type: request type for handel generic function
    func getPatchDataWith(type: MainModelRequestType) {
        loading()
        checkCancellation()
        
        apiTask = Task(priority: taskPriority) { [weak self] in
            guard let self = self else { return }
            //print(Thread.isMainThread)
            let response: AnyPublisher<PatchModel, APIError>? = await weatherApiUseCaseProtocol?.execute(title: "My personal")
            await responseHandler(response: response, requestType: type)
        }
    }
    
    /// Loading activity
    private func loading() {
        //guard apiTask == nil else { return }
        guard !isLoading else { return }
        isLoading = true
    }
    
    private func checkCancellation() {
        apiTask?.cancel()
        apiTask = nil
        try? Task.checkCancellation()
    }
    
    /// Handel the response  in generally
    /// - Parameters:
    ///   - response: api response
    ///   - requestType: type of the response
    private func responseHandler<T: Codable>(response: AnyPublisher<T, APIError>?,
                         requestType: MainModelRequestType) async {
        response?.sink { [weak self] completion in
            guard let self = self else { return }
            Task { @MainActor in self.errorResponseWith(type: requestType,
                                                               with: completion)
            }
        } receiveValue: { [weak self] response in
            guard let self = self else { return }
            Task { @MainActor in self.successResponseWith(type: requestType,
                                                                 and: response)
            }
        }.store(in: &cancelable)
    }
}

// Handel request responses & errors
extension MainViewModel {
    
    /// Process error response  generally
    /// - Parameters:
    ///   - type: response  type
    ///   - completion: response model
    private func errorResponseWith(type: MainModelRequestType,
                                          with completion: Subscribers.Completion<APIError>){
        switch completion { case .finished: break; case .failure(let error):
            switch type {
            case .weatherDetail, .tMDBDetails, .postData, .putData, .patchData:
                defer { isLoading = false }
                    self.showAlert = true
                    self.alertMessage = AlertMessage(title: "Error!",
                                                     message: error.errorDescription ?? "N/A")
            }
        }
    }
    
    /// Process success response  generally
    /// - Parameters:
    ///   - type: response  type
    ///   - response: response model
    private func successResponseWith<T: Codable>(type: MainModelRequestType,
                                                         and response: T) {
        //self.logger.info("SUCCESS:")
        defer { isLoading = false }
        switch type {
        case .weatherDetail:
            //Task { @MainActor in // DispatchQueue.main.async {}
            guard let response = response as? WeatherModel else { return }
            self.weatherModel = response
            //}
        case .tMDBDetails:
            guard let response = response as? TMDBModel else { return }
            self.tMDBModel = response
        case .postData:
            guard let response = response as? JsonPlaceHolderModel else { return }
            self.jsonPlaceHolderModel = response
        case .putData:
            guard let response = response as? JsonPlaceHolderModel else { return }
            self.jsonPlaceHolderModel = response
        case .patchData:
            guard let response = response as? PatchModel else { return }
            self.patchModel = response
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

class TAskViewModel {
    private var task: Task<Void, Never>? // Using "private var task"

    func fetchData() {
        task = Task {
            do {
                let data = try await performNetworkRequest()
                print("Data received: \(data)")
            } catch {
                print("Task failed with error: \(error)")
            }
        }
    }

    func cancelTask() {
        task?.cancel()
    }

    private func performNetworkRequest() async throws -> String {
        // Simulate network request
        try await Task.sleep(nanoseconds: 2_000_000_000)
        return "Sample Data"
    }
}

/*
func fetchData() async {
    do {
        print("Task has started")
        try await apiCall()
        print("Task has ended successfully")
    } catch where error is CancellationError {
        print("Task was cancelled")
    } catch {
        // Show UI error
    }
}*/
