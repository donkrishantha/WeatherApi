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

/// A struct representing the data transfer object for a post.
struct PostDTO: Codable {
    let userId: Int
    let title: String
    let body: String
}

extension PostDTO {
    /// Converts the `PostDTO` data to JSON format for use in a request body.
    ///
    /// - Returns: A `Data` object representing the post data in JSON format, or `nil` if the conversion fails.
    func toJSONData() -> Data? {
        let jsonObject: [String: Any] = [
            "userId": userId,
            "title": title,
            "body": body
        ]
        return try? JSONSerialization.data(withJSONObject: jsonObject, options: [])
    }
}
