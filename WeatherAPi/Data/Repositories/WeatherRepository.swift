//
//  WeatherApiRepo.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 16/01/2024.
//

import Foundation
import Combine

protocol WeatherApiRepoProtocol {
    
    func searchWeatherData(params: WeatherDetailParams) async -> AnyPublisher<WeatherRowData, ApiError>
}

struct WeatherApiRepoImplement: WeatherApiRepoProtocol {
    
    private var apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func searchWeatherData(params: WeatherDetailParams) async -> AnyPublisher<WeatherRowData, ApiError> {
        let endpoint = EventsEndpoints.getCurrentWeatherDetails(accessKey: AppConstants.Api.apiKey,
                                                                   query: params.searchTerm)
        let request = RequestModel(endPoint: endpoint, method: .get)
        return await apiClient.request(request, responseModel: WeatherRowData.self)
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
