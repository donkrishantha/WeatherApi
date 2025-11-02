//
//  WeatherApiRepo.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 16/01/2024.
//

import Foundation
import Combine

protocol WeatherApiRepoProtocol {
    //associatedtype Element
    func searchWeatherData(params: WeatherDetailParams) async -> AnyPublisher<WeatherRowData, ApiError>
    func getTMDBDetails(accountId: Int) async -> AnyPublisher<TMDBModel, ApiError>
}

struct WeatherApiRepoImplement: WeatherApiRepoProtocol {
    //typealias Element = AnyPublisher<WeatherRowData, ApiError>
    private var apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func searchWeatherData(params: WeatherDetailParams) async -> AnyPublisher<WeatherRowData, ApiError> {
        let endpoint = EventsEndpoints.getCurrentWeatherDetails(query: params.searchTerm)
        let request = RequestModel<Any>(.get, endpoint)
        return await apiClient.request(request, responseModel: WeatherRowData.self)
    }
    
    func getTMDBDetails(accountId: Int) async -> AnyPublisher<TMDBModel, ApiError> {
        let endPoint = TMDBEndPoint.getTMDBDetails(accountId: accountId)
        let request = RequestModel<Any>(.get, endPoint)
        return await apiClient.request(request, responseModel: TMDBModel.self)
    }
    
    /*
     func searchWeatherData2(searchTerm: String, accessKey: String) async -> AnyPublisher<WeatherDetail, ApiError> {
     let endpoint = WeatherEndpoint.getCurrentWeatherDetails(accessKey: accessKey, query: searchTerm)
     let req = RequestModel(endPoint: endpoint)
     return await networkManager.request(req)
     }
     
     func searchWeatherData(searchTerm: String, accessKey: String) async -> AnyPublisher<ResponseDTO<WeatherDetailDto, ApiError> {
     //let endpoint = EventsEndpoints.getCurrentWeatherDetails(accessKey: searchTerm, query: accessKey)
     //let endpoint = WeatherEndpoint.getCurrentWeatherDetails(accessKey: accessKey, query: searchTerm)
     let endpointNew = EventsEndpoints.getCurrentWeatherDetails(accessKey: accessKey, query: searchTerm)
     let request = RequestModel(endPoint: endpointNew, method: .get)
     return await networkManager.request(request)
     }*/
}
