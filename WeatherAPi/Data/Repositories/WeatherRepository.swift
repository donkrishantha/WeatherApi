//
//  WeatherApiRepo.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 16/01/2024.
//

import Foundation
import Combine
import Network

protocol WeatherApiRepoProtocol {
    //associatedtype Element
    
    // Weather api
    func searchWeatherData(params: WeatherDetailParams) async -> AnyPublisher<WeatherRowData, APIError>
    
    // TMDN
    func getTMDBDetails(accountId: Int) async -> AnyPublisher<TMDBModel, APIError>
    
    // JSONPlaceholderApi
    func getJsonPlaceHolderPostRequest(parms: JsonPlaceHolderPostParams) async -> AnyPublisher<JsonPlaceHolderModel, APIError>
    func getJsonPlaceHolderPutRequest(parms: JsonPlaceHolderPostParams) async -> AnyPublisher<JsonPlaceHolderModel, APIError>
    func getJsonPlaceHolderPatchRequest(title: String) async -> AnyPublisher<PatchRequestModel, APIError>
}

struct WeatherApiRepoImplement {
    //typealias Element = AnyPublisher<WeatherRowData, ApiError>
    private var apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
}

// Weather api
extension WeatherApiRepoImplement: WeatherApiRepoProtocol {
    
    func searchWeatherData(params: WeatherDetailParams) async -> AnyPublisher<WeatherRowData, APIError> {
        let endpoint = EventsEndpoints.getCurrentWeatherDetails(query: params.searchTerm)
        let request = RequestModel<Any>(.get, endpoint)
        return await apiClient.request(request, responseModel: WeatherRowData.self)
    }
    
    func getTMDBDetails(accountId: Int) async -> AnyPublisher<TMDBModel, APIError> {
        let endPoint = TMDBEndPoint.getTMDBDetails(accountId: accountId)
        let request = RequestModel<Any>(.get, endPoint)
        return await apiClient.request(request, responseModel: TMDBModel.self)
    }
    
    // JSONPlaceholderApi
    func getJsonPlaceHolderPostRequest(parms: JsonPlaceHolderPostParams) async -> AnyPublisher<JsonPlaceHolderModel, APIError> {
        let endpoint = JsonPlaceHolderEndpoint.postWebRequest
        let params: [String: Any] = [
            "title": parms.title,
            "body": parms.body,
            "userId": parms.userId
        ]
        let request = RequestModel<Any>(.post, endpoint, with: params)
        return await apiClient.request(request, responseModel: JsonPlaceHolderModel.self)
    }
    
    func getJsonPlaceHolderPutRequest(parms: JsonPlaceHolderPostParams) async -> AnyPublisher<JsonPlaceHolderModel, APIError> {
        let endPoint = JsonPlaceHolderEndpoint.putWebRequest
        let params: [String: Any] = [
            "title": parms.title,
            "body": parms.body,
            "userId": parms.userId
        ]
        let request = RequestModel<Any>(.put, endPoint, with: params)
        return await apiClient.request(request, responseModel: JsonPlaceHolderModel.self)
    }
    
    func getJsonPlaceHolderPatchRequest(title: String) async -> AnyPublisher<PatchRequestModel, APIError> {
        let endPoint = JsonPlaceHolderEndpoint.patchWebRequest
        let params: [String: Any] = [
            "title": title
        ]
        let request = RequestModel<Any>(.patch, endPoint, with: params)
        return await apiClient.request(request, responseModel: PatchRequestModel.self)
    }
}
