//
//  WeatherDetailDTO.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 21/07/2024.
//

import Foundation

struct ResponseDTO<Data: Decodable>: Decodable {
    let data: Data
}

//extension ResponseDTO: EmptyResponse where Data: EmptyResponse {
//    static func emptyValue() -> ResponseDTO<Data> {
//        ResponseDTO(data: Data.emptyValue())
//    }
//}


struct WeatherDetailDto: Codable {
    let currentLocation: CurrentLocationDto
    let currentWeather: CurrentWeatherDto
}

struct CurrentWeatherDto: Codable {
    let observationTime, windDirection: String
    let temperature, windSpeed, windDegree, pressure, humidity, cloudCover, feelsLike, uvIndex, visibility: Int
    let weatherDescriptions, weatherIcons : [String]
}

struct CurrentLocationDto: Codable {
    let name, country,region, latitude, longitude, localTime : String
}
