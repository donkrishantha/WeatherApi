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
    private let coordinator: AppCoordinatorProtocol
    
    init(repository: WeatherApiRepoImplement,
         coordinator: AppCoordinatorProtocol) {
        self.repository = repository
        self.coordinator = coordinator
    }
}

extension DetailViewModel {
    
//    func getWeatherDetails() async {
//        await self.repository.searchWeatherData(searchTerm: <#T##String#>, accessKey: <#T##String#>)
//    }
    
}
