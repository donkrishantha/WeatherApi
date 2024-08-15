//
//  MainViewModel.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 16/01/2024.
//

import Foundation
import Combine
import OSLog

final class MainViewModel: ObservableObject {
    
    // MARK: - Output
    @Published private(set) var weatherModel: WeatherModel?
    @Published var alertMessage: AlertMessage?
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
    private let repository: WeatherApiRepoImplement
    private var isSending = false
    
    var buttonTitle: String { isSending ? "Sending..." : "Send" }
    var isSendingDisabled: Bool { isSending || searchText.isEmpty }
    
    
    // MARK: - Initialisation
    init(repository: WeatherApiRepoImplement) {
        self.repository = repository
        self.loadLocalJsonData()
        self.searchLocation()
    }
    
    // MARK: - De-Initialisation
    deinit {
        print("++++++++++++++++++++++++++DE -Init++++++++++++++++++++++++++++++++++++++++")
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
        //Task(priority: .medium) { await getWeatherDetail(searchText) }
        guard !searchText.isEmpty else { return }
        
        isSending = true
        
        Task (priority: .medium) {
            await getWeatherDetail(searchText)
            self.searchText = ""
            isSending = false
        }
    }
    
    private func getWeatherDetail(_ text: String) async {
        /// request parameters
        let requestParameters = WeatherDetailParams(searchTerm: text)
        
        logger.trace("REQUEST: /current")
        
        /// request to get "weather details"
        await self.repository.searchWeatherData(params: requestParameters)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.processErrorResponse(completion: completion)
            } receiveValue: { [weak self] rowWeatherResponse in
                guard let self = self else { return }
                self.processSuccessResponse(rowWeatherResponse: rowWeatherResponse)
            }.store(in: &cancelable)
    }
    
    /// process error in further
    private func processErrorResponse(completion: Subscribers.Completion<NetworkRequestError>) {
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
       // DispatchQueue.main.async{
            logger.info("SUCCESS:")
            self.weatherModel = WeatherModel(data: rowWeatherResponse)
        ///}
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
        DispatchQueue.main.async{
            self.weatherModel = WeatherModel(data: rawWeather)
        }
    }
}

/// request parameters
struct WeatherDetailParams {
    let searchTerm: String
    
    fileprivate init(searchTerm: String) {
        self.searchTerm = searchTerm
    }
}

 
