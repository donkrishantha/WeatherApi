//
//  MockHttpClient.swift
//  WeatherAPiTests
//
//  Created by Gayan Dias on 04/08/2024.
//

import XCTest
import Foundation
import Combine
@testable import WeatherAPi

final class MockHTTPClient: APIClient, Mockable {
    
    func request<T: Codable>(_ request: WeatherAPi.RequestModel, responseModel: T.Type?) async ->
    AnyPublisher<T,NetworkRequestError> {
        
        return Just(loadJSON(filename: "mock_weather_detail", type: responseModel.self!) as T)
            .setFailureType(to: NetworkRequestError.self)
            .eraseToAnyPublisher()
        
    }
    
//    func request<T: Codable>(_ request: RequestModel, responseModel: T.Type?) async -> AnyPublisher<T, NetworkRequestError> {
//        if sendError {
//            return Fail(error: NetworkRequestError.invalidResponse(error: "Response not valid"))
//                .eraseToAnyPublisher()
//        } else {
//            return Just(loadJSON(filename: request.endPoint.mockFile!, type: responseModel.self!) as T)
//                .setFailureType(to: NetworkRequestError.self)
//                .eraseToAnyPublisher()
//        }
//    }
    
//    func fetch<T>(url: URL, completion: @escaping (Result<[T], Error>) -> Void) where T : Decodable, T : Encodable {
//        
//        return loadJson(filename: "CatResponse",
//                        extensionType: .json,
//                        type: T.self, completion: completion)
//    }
    
}

