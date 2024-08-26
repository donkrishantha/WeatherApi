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

final class MockWeatherRepository: Mockable, WeatherApiRepoProtocol {
    
    var sendError: Bool
    var mockFile: String?
    
    init(sendError: Bool, mockFile: String? = nil) {
        self.sendError = sendError
        self.mockFile = mockFile
    }
    
    func searchWeatherData(params: WeatherDetailParams) async -> AnyPublisher<WeatherRowData, ApiError> {
        if sendError {
            return Fail(error: ApiError.apiError("Error"))
                .eraseToAnyPublisher()
        } else {
            let mockWeatherDetail = "mock_weather_detail"
            return Just(loadJSON(filename: mockWeatherDetail, type: WeatherRowData.self))
                .setFailureType(to: ApiError.self)
                .eraseToAnyPublisher()
        }
    }
}

