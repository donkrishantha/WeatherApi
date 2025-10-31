//
//  ImageUploadUseCase2.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 25/10/2025.
//

import Foundation
import Combine

protocol WeatherApiUseCaseProtocol {
    ///associatedtype Element
    ///func execute(params: WeatherDetailParams) async -> Element
    func execute(params: WeatherDetailParams) async -> AnyPublisher<WeatherRowData, ApiError>
}

final class WeatherApiUseCaseImple: WeatherApiUseCaseProtocol {

    //typealias Element = AnyPublisher<WeatherRowData, ApiError>
    private let repository: WeatherApiRepoProtocol

    init(repository: any WeatherApiRepoProtocol) {
        self.repository = repository
    }

    func execute(params: WeatherDetailParams) async -> AnyPublisher<WeatherRowData, ApiError> {
        let result: AnyPublisher<WeatherRowData, ApiError> = await repository.searchWeatherData(params: params)
        return result
    }
}

//protocol WeatherApiUseCaseProtocol {
//    ///associatedtype Element
//    ///func execute(params: WeatherDetailParams) async -> Element
//    func execute(params: WeatherDetailParams) async -> AnyPublisher<WeatherRowData, ApiError>
//}
//
//final class WeatherApiUseCaseImple: WeatherApiUseCaseProtocol {
//
//    //typealias Element = AnyPublisher<WeatherRowData, ApiError>
//    private let repository: WeatherApiRepoProtocol
//
//    init(repository: any WeatherApiRepoProtocol) {
//        self.repository = repository
//    }
//
//    func execute(params: WeatherDetailParams) async -> AnyPublisher<WeatherRowData, ApiError> {
//        let result: AnyPublisher<WeatherRowData, ApiError> = await repository.searchWeatherData(params: params)
//        return result
//
//        let endpoint = EventsEndpoints.getCurrentWeatherDetails(accessKey: AppConstants.Api.apiKey,
//                                                                query: params.searchTerm)
//        let request = RequestModel(endPoint: endpoint, method: .get)
//        return await apiClient.request(request, responseModel: WeatherRowData.self)
//    }
//}
