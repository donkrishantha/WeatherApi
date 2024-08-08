//
//  MainViewModel.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 16/01/2024.
//

import Foundation
import Combine
import UIKit

protocol MainViewModelInputInterface: ObservableObject {
    var value: String { get set }
    var isTryThis: Bool { get }
}

final class MainViewModel2: MainViewModelInputInterface {
    var value: String
    var isTryThis: Bool
    
    init(value: String, isTryThis: Bool) {
        self.value = value
        self.isTryThis = isTryThis
    }
}

final class MainViewModel: ObservableObject {
    
    var cancelable = Set<AnyCancellable>()
    let apiClient = NetworkManager()
    @Published var weatherDetails: WeatherDetail?
    @Published var alertMessage: AlertMessage?
    @Published var showAlert = false
    private let repository: WeatherApiRepoImplement
    
    @Published var searchText: String = ""
    
    // Network
    @Published var networkStatus: NewNetworkStatus = .undetermined
    var networkMonitor: NetworkPathMonitorProtocol
    
    // MARK: Initialisation
    
    init(repository: WeatherApiRepoImplement, networkMonitor: NetworkPathMonitorProtocol) {
        self.repository = repository
        self.networkMonitor = networkMonitor
        //self.checkRechability()
    }
    
    // MARK: - Public properties
    var weatherDescription: String {
        "Description: \(weatherDetails?.currentWeather.weatherDescription ?? "")"
    }
    
    var name: String {
        "name: \(weatherDetails?.currentLocation.name ?? "...")"
    }
    
    var temperature: String {
        "temperature: \(weatherDetails?.currentWeather.temperature ?? 0)"
    }
    
    var weatherIcon: String {
        weatherDetails?.currentWeather.weatherIcon ?? ""
    }
    
    deinit {
        networkMonitor.cancel()
    }
}

extension MainViewModel {
    
    // MARK: Helper Methods
    func checkOnlineStatus() {
        let _ = NetworkStatus.shared.startMonitoring()
        let online = NetworkStatus.shared.isConnected
        if online {
            print("Online")
        } else {
            print("Offline")
        }
    }
    
    func loadAsyncData() {
        Task(priority: .medium) {
            await getApiData()
        }
    }
    
    @MainActor
    private func getApiData(location: String? = nil) async {
        await self.repository.searchWeatherData(searchTerm: location ?? "New york",
                                                accessKey: AppConstants.Api.apiKey )
        .sink(
            receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    debugPrint("Finished")
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.showAlert = true
                        self.alertMessage = AlertMessage(title: "Error", message: error.errorDescription ?? "N/A")
                        //self.alertMessage = AlertMessage(error: error)
                    }
                }
            },
            receiveValue: { [weak self] weatherDetail in
                guard let self = self else { return }
                DispatchQueue.main.async{
                    self.weatherDetails = weatherDetail
                }
            }
        )
        .store(in: &cancelable)
    }
    
    func checkRechability() {
        self.networkMonitor.pathUpdateHandler = { [weak self] status in
            DispatchQueue.main.async { [weak self] in
                self?.networkStatus = status == .satisfied ? .connected : .notConnected
                if status == .satisfied {
                    self?.loadAsyncData()
                    self?.networkMonitor.cancel()
                } else {
                    self?.showAlert = true
                    self?.alertMessage = AlertMessage(title: "Offline!", message: "The connection appear to be offline, Please check your connction")
                }
            }
        }
        self.networkMonitor.start(queue: DispatchQueue.global())
    }
}

