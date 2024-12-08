//
//  DetailViewMoidel.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 16/01/2024.
//

import Foundation
import Combine

final class DetailViewModel: ObservableObject {
    
    var subscriptions = Set<AnyCancellable>()
    private let repository: WeatherApiRepoImplement
    //private let coordinator: AppCoordinatorProtocol
    
    init(repository: WeatherApiRepoImplement) {
        self.repository = repository
    }
    
    func testObserverDesignPattern(count: Int) {
        let subject = Subject()
        let counterDetail = WeatherApp()
        let loginViewModel = WeatherDemo()
        
        subject.registerObserver(counterDetail)
        subject.registerObserver(loginViewModel)
        
        //subject.setMeasurements(temp: 0.0, humidity: 0.0, pressure: Double(count))
        subject.setModerate(temp: 0.0, humidity: 0.0, pressure: Double(count))
        
        subject.removeObserver(counterDetail)
        subject.removeObserver(loginViewModel)
    }
}

extension DetailViewModel {
    
//    func getWeatherDetails() async {
//        await self.repository.searchWeatherData(searchTerm: <#T##String#>, accessKey: <#T##String#>)
//    }
    
//    func updateCounter() {
//        let weatherStation = WeatherStation()
//        let weatherApp = DetailViewModel(repository: WeatherApiRepoImplement(apiClient: APIClient()))
//
//        //register the observer
//        weatherStation.registerObserver(weatherApp)
//
//        //set the measurements and notify the observer
//        weatherStation.setMeasurements(temp: 72.0, humidity: 65.0, pressure: 1013.25)
//        // Output: "WeatherApp: New weather data received: temp 72.0 humidity 65.0 pressure 1013.25"
//
//        //remove the observer
//        weatherStation.removeObserver(weatherApp)
//    }
}
