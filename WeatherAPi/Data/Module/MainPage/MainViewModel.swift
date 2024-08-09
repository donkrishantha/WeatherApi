//
//  MainViewModel.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 16/01/2024.
//

import Foundation
import Combine

final class MainViewModel: ObservableObject {
    // MARK: - Output
    @Published private var weatherModel: WeatherModel?
    @Published var alertMessage: AlertMessage?
    @Published var showAlert = false
    
    var weatherDescription: String { get { String(format: "%@ %@", "Description:",weatherModel?.weatherDescription ?? "N/A") }}
    var weatherName: String { get { String(format: "%@ %@", "Name:",weatherModel?.weatherName ?? "N/A") }}
    var temperature: String { get { String(format: "%@ %i", "Temperature:", weatherModel?.temperature ?? 0) }}
    var weatherIcon: String { get { weatherModel?.weatherIcon ?? "N/A" }}
    var observationDate: String {get { String(format: "%@ %@", "Date:", weatherModel?.observationDate?.roundTripDate(style: .medium) ?? "N/A") }}
    var observationTime: String {get { String(format: "%@ %@", "Time:", weatherModel?.observationTime?.timeIn24HourFormat() ?? "N/A") }}
    
    // MARK: - Input
    @Published var searchText: String = ""
    private(set) fileprivate var cancelable: Set<AnyCancellable> = []
    private let repository: WeatherApiRepoImplement
    
    // MARK: - Initialisation
    init(repository: WeatherApiRepoImplement) {
        self.repository = repository
        //self.loadLocalJsonData()
    }
    
    // MARK: - De-Initialisation
    deinit {}
}

extension MainViewModel {
    /// request data async way
    func loadAsyncData() {
        Task(priority: .medium) { await getWeatherDetail() }
    }
    
    private func getWeatherDetail(location: String? = nil) async {
        /// request parameters
        let requestParameters = WeatherDetailParams(searchTerm: location ?? "New York")
        
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
            DispatchQueue.main.async {
                self.showAlert = true
                self.alertMessage = AlertMessage(title: "Error!", message: error.errorDescription ?? "N/A")
            }
        }
    }
    
    /// process response in further
    private func processSuccessResponse(rowWeatherResponse: WeatherRowData) {
        DispatchQueue.main.async{
            self.weatherModel = WeatherModel(data: rowWeatherResponse)
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
        self.weatherModel = WeatherModel(data: rawWeather)
    }
}

/// request parameters
struct WeatherDetailParams {
    let searchTerm: String
    
    fileprivate init(searchTerm: String) {
        self.searchTerm = searchTerm
    }
}

