//
//  DependencyContainer.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 04/09/2024.
//

import Foundation

final class DependencyContainer {
    
    private lazy var urlSession = URLSession(
        configuration: URLSessionConfiguration.default
    )

    private lazy var apiClient: APIClient = APIClient(
        session: urlSession
    )
    
    private(set) lazy var weatherApiRepository: WeatherApiRepoProtocol = WeatherApiRepoImplement(
        apiClient: apiClient
    )
}
