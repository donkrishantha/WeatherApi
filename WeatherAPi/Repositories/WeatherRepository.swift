//
//  WeatherApiRepo.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 16/01/2024.
//

import Foundation
import Combine

protocol WeatherApiRepoProtocol {
    func searchWeatherData(searchTerm: String, accessKey: String) async -> AnyPublisher<WeatherDetail,
                                                                                        NetworkRequestError>
}

struct WeatherApiRepoImplement: WeatherApiRepoProtocol {
    func searchWeatherData(searchTerm: String, accessKey: String) async -> AnyPublisher<WeatherDetail, NetworkRequestError> {
        let endpointNew = EventsEndpoints.getCurrentWeatherDetails(accessKey: accessKey, query: searchTerm)
        let request = RequestModel(endPoint: endpointNew, method: .get)
        return await networkManager.request(request, responseModel: WeatherDetail.self)
    }
    
    private var networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
//    func searchWeatherData2(searchTerm: String, accessKey: String) async -> AnyPublisher<WeatherDetail, NetworkRequestError> {
//        let endpoint = WeatherEndpoint.getCurrentWeatherDetails(accessKey: accessKey, query: searchTerm)
//        let req = RequestModel(endPoint: endpoint)
//        return await networkManager.request(req)
//    }
    
//    func searchWeatherData(searchTerm: String, accessKey: String) async -> AnyPublisher<ResponseDTO<WeatherDetailDto, NetworkRequestError> {
//        //let endpoint = EventsEndpoints.getCurrentWeatherDetails(accessKey: searchTerm, query: accessKey)
//        //let endpoint = WeatherEndpoint.getCurrentWeatherDetails(accessKey: accessKey, query: searchTerm)
//        let endpointNew = EventsEndpoints.getCurrentWeatherDetails(accessKey: accessKey, query: searchTerm)
//        let request = RequestModel(endPoint: endpointNew, method: .get)
//        return await networkManager.request(request)
//    }
}
