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

enum AsyncErrors: Error {
    case dataNotAvailable
    case dataExist
}

final class MainViewModel: ObservableObject {
    
    // MARK: - Output
    @Published private(set) var weatherModel: WeatherModel?
    @Published private(set) var alertMessage: AlertMessage?
    @Published var showAlert = false
    private let logger = Logger.dataStore
    
    var weatherDescription: String { get { "Description" + (weatherModel?.weatherDescription ?? "N/A") }}
    
    var weatherName: String { get { "Name:" + (weatherModel?.weatherName ?? "N/A")}}
    
    var temperature: String { get { String(format: "%@ %i", "Temperature:", weatherModel?.temperature ?? 0)}}
    
    var weatherIcon: String { get { weatherModel?.weatherIcon ?? "N/A"}}
    
    var observationDate: String { get { "Date:" + (weatherModel?.observationDate?.roundTripDate(style: .medium) ?? "N/A")}}
    
    var observationTime: String { get {"Time:" + (weatherModel?.observationTime?.timeIn24HourFormat() ?? "N/A")}}
    
    // MARK: - Input
    @Published var searchText: String = ""
    private(set) fileprivate var cancelable: Set<AnyCancellable> = []
    private var loadDataSubject = PassthroughSubject<Bool, ApiError>()
    private let repository: (any WeatherApiRepoProtocol)?
    private(set) var isRequestSending = false
    
    var buttonTitle: String { isRequestSending ? "Sending..." : "Send" }
    var isRequestSendingDisabled: Bool { isRequestSending || searchText.isEmpty }
    
    
    // MARK: - Initialisation
    init(repository: any WeatherApiRepoProtocol = WeatherApiRepoImplement(apiClient: APIClient())) {
        //init(repository: WeatherApiRepoProtocol = MockWeatherRepository()) {
        self.repository = repository
        print(searchText)
        if !searchText.isEmpty {
            //self.loadLocalJsonData()
            self.loadAsyncData(searchText)
        }
        self.searchLocation()
    }
    
    // MARK: - De-Initialisation
    deinit {
        print("DE INIT")
    }
    
    func testAsyncThrows(count: Int) async throws -> Int {
        if count > 3 {
            throw AsyncErrors.dataExist
        }
        
        return count
    }
    
    func callAsyncThrows() {
        Task{
            do {
                let value = try? await self.testAsyncThrows(count: 2)
                print("error definition : \(value ?? 0)")
            } catch {
                print("Error definition")
            }
        }
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
            self.searchText = ""
            isRequestSending = false
        }
    }
    
    func getWeatherDetail(_ text: String) async {
        /// request parameters
        let requestParameters = WeatherDetailParams(searchTerm: text)
        
        /// validate repository
        guard repository != nil else {
            self.showAlert = true
            self.alertMessage = AlertMessage(title: "Error!", message: "Missing service")
            return
        }
        
        /// logger status
        logger.trace("REQUEST: /current")
        
        /// request to get "weather details"
        let searchWeatherData = await self.repository?.searchWeatherData(params: requestParameters) as? AnyPublisher<WeatherRowData, ApiError>
        searchWeatherData?
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.processErrorResponse(completion: completion)
            } receiveValue: { [weak self] rowWeatherResponse in
                guard let self = self else { return }
                self.processSuccessResponse(rowWeatherResponse: rowWeatherResponse)
            }.store(in: &cancelable)
        return
    }
    
    /// process error in further
    private func processErrorResponse(completion: Subscribers.Completion<ApiError>) {
        switch completion { case .finished: break; case .failure(let error):
            logger.error("ERROR : \(error)")
            DispatchQueue.main.async {
                self.showAlert = true
                self.alertMessage = AlertMessage(title: "Error!", message: error.errorDescription ?? "N/A")
            }
        }
    }
    
    /// process response in further
    private func processSuccessResponse(rowWeatherResponse: WeatherRowData) {
        self.logger.info("SUCCESS:")
        self.weatherModel = WeatherModel(data: rowWeatherResponse)
    }
}

extension MainViewModel {
    /// load local json data
    fileprivate func loadLocalJsonData() {
        guard let data = FileLoader.readLocalFile("mock_weather_data") else {
            fatalError("Unable to locate file \"weatherData.json\" in main bundle.")
        }
        
        let rawWeather = FileLoader.loadJson(data)
        self.logger.debug("Local database")
        //DispatchQueue.main.async{
        self.weatherModel = WeatherModel(data: rawWeather)
        //}
    }
}

/// request parameters
struct WeatherDetailParams {
    let searchTerm: String
    
    init(searchTerm: String) {
        self.searchTerm = searchTerm
    }
}

/// Observable pattern design.
class WeatherApp: ObserverProtocol {
    func moderate(temp: Double, humidity: Double, pressure: Double) {
        print("MainViewModel: temp \(temp) humidity \(humidity) pressure \(pressure)")
    }
    
    func update(temp: Double, humidity: Double, pressure: Double) {
        print("MainViewModel: temp \(temp) humidity \(humidity) pressure \(pressure)")
    }
}
