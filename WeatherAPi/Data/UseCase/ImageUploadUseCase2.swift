//
//  ImageUploadUseCase2.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 25/10/2025.
//

import Foundation
import Combine
import Network

protocol WeatherApiUseCaseProtocol {
    func execute(params: WeatherDetailParams) async -> AnyPublisher<WeatherRowData, APIError>
    func execute(accountId: Int) async -> AnyPublisher<TMDBModel, APIError>
    
    // JSONPlaceholderApi
    func execute(params: JsonPlaceHolderPostParams) async -> AnyPublisher<JsonPlaceHolderModel, APIError>
    func execute2(params: JsonPlaceHolderPostParams) async -> AnyPublisher<JsonPlaceHolderModel, APIError>
    func execute(title: String) async -> AnyPublisher<PatchModel, APIError>
}

final class WeatherApiUseCaseImple {
    private let repository: WeatherApiRepoProtocol
    
    init(repository: any WeatherApiRepoProtocol) {
        self.repository = repository
    }
}

extension WeatherApiUseCaseImple: WeatherApiUseCaseProtocol {

    func execute(params: WeatherDetailParams) async -> AnyPublisher<WeatherRowData, APIError> {
        let result: AnyPublisher<WeatherRowData, APIError> = await repository.searchWeatherData(params: params)
        return result
    }
    
    func execute(accountId: Int) async -> AnyPublisher<TMDBModel, APIError> {
        let result: AnyPublisher<TMDBModel, APIError> = await repository.getTMDBDetails(accountId: accountId)
        return result
    }
    
    // JSONPlaceholderApi
    func execute(params: JsonPlaceHolderPostParams) async -> AnyPublisher<JsonPlaceHolderModel, APIError> {
        let result: AnyPublisher<JsonPlaceHolderModel, APIError> = await repository.getJsonPlaceHolderPostRequest(parms: params)
        return result
    }
    
    func execute2(params: JsonPlaceHolderPostParams) async -> AnyPublisher<JsonPlaceHolderModel, APIError> {
        let result: AnyPublisher<JsonPlaceHolderModel, APIError> = await repository.getJsonPlaceHolderPutRequest(parms: params)
        return result
    }
    
    func execute(title: String) async -> AnyPublisher<PatchModel, APIError> {
        let result: AnyPublisher<PatchModel, APIError> = await repository.getJsonPlaceHolderPatchRequest(title: title)
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
