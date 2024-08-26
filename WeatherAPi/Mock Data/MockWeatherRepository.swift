//
//  MockWeatherRepository.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 15/08/2024.
//

import Foundation
import Combine

/*
class MockWeatherRepository: WeatherApiRepoProtocol, Mockable2 {
    
    func searchWeatherData(params: WeatherDetailParams) async -> AnyPublisher<WeatherRowData, ApiError> {
        return Just(loadJSON2(filename: "mock_weather_detail", type: WeatherRowData.self))
            .setFailureType(to: ApiError.self)
            .eraseToAnyPublisher()
    }
}

protocol Mockable2: AnyObject {
    var bundle: Bundle { get }
    func loadJSON2<T: Decodable>(filename: String, type: T.Type) -> T
}

extension Mockable2 {
    var bundle: Bundle {
        return Bundle(for: type(of: self))
    }

    func loadJSON2<T: Decodable>(filename: String, type: T.Type) -> T {
        guard let path = bundle.url(forResource: filename, withExtension: "json") else {
            fatalError("Failed to load JSON")
        }

        do {
            let data = try Data(contentsOf: path)
            let decodedObject = try JSONDecoder().decode(type, from: data)

            return decodedObject
        } catch {
            fatalError("Failed to decode loaded JSON")
        }
    }
}*/
