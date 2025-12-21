//
//  WeatherDetail.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 16/01/2024.
//

import Foundation

/// Domain Model
struct WeatherRowData {
    let currentLocation: CurrentLocation
    let currentWeather: CurrentWeather
}

extension WeatherRowData: Codable {
    enum CodingKeys: String, CodingKey {
        case currentLocation = "location"
        case currentWeather = "current"
    }
}

struct CurrentLocation {
    let name: String
    let country: String
    let region: String
    let latitude: String
    let longitude: String
    let localTime: String
}

extension CurrentLocation: Codable {
    enum CodingKeys: String, CodingKey {
        case name, country, region
        case latitude = "lat"
        case longitude = "lon"
        case localTime = "localtime"
    }
}

struct CurrentWeather: Codable {
    let observationTime, windDirection: String
    let temperature, windSpeed, windDegree, pressure, humidity, cloudCover, feelsLike, uvIndex, visibility: Int
    private let weatherDescriptions, weatherIcons : [String]
    
    enum CodingKeys: String, CodingKey {
        case observationTime = "observation_time"
        case temperature, pressure, humidity, visibility
        case weatherDescriptions = "weather_descriptions"
        case weatherIcons = "weather_icons"
        case windSpeed = "wind_speed"
        case windDegree = "wind_degree"
        case windDirection = "wind_dir"
        case cloudCover = "cloudcover"
        case feelsLike = "feelslike"
        case uvIndex = "uv_index"
    }
    
    var weatherDescription: String {
        weatherDescriptions.first ?? ""
    }
    
    var weatherIcon: String {
        weatherIcons.first ?? ""
    }
}

/// UI Model
struct WeatherModel: Codable, Sendable {
    let weatherDescription: String?
    let temperature: String?
    let weatherIcon: String?
    let observationTime: String?
    
    init(data: CurrentWeather) {self.weatherDescription = data.weatherDescription
        self.temperature = String(format: "%i", data.temperature)
        self.weatherIcon = data.weatherIcon
        self.observationTime = data.observationTime.timeIn24HourFormat()
    }
}


