//
//  WeatherDetail.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 16/01/2024.
//

import Foundation

struct WeatherRowData: Codable {
    let currentLocation: CurrentLocation
    let currentWeather: CurrentWeather
    
    enum CodingKeys: String, CodingKey {
        case currentLocation = "location"
        case currentWeather = "current"
    }
}

struct CurrentLocation: Codable {
    let name,country, region, latitude, longitude, localTime : String
    
    enum CodingKeys: String, CodingKey {
        case name, country, region
        case latitude = "lat"
        case longitude = "lon"
        case localTime = "localtime"
    }
    
    /*init(from dto: CurrentLocationDto) {
        self.name = dto.name
        self.country = dto.country
        self.region = dto.region
        self.latitude = dto.latitude
        self.longitude = dto.longitude
        self.localTime = dto.localTime
    }*/
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
    
    /*init(from dto: CurrentWeatherDto) {
        self.observationTime = dto.observationTime
        self.windDirection = dto.windDirection
        
        self.temperature = dto.temperature
        self.windSpeed = dto.windSpeed
        self.windDegree = dto.windDegree
        self.pressure = dto.pressure
        self.humidity = dto.humidity
        self.cloudCover = dto.cloudCover
        self.feelsLike = dto.feelsLike
        self.uvIndex = dto.uvIndex
        self.visibility = dto.visibility
        
        self.weatherDescriptions = dto.weatherDescriptions
        self.weatherIcons = dto.weatherIcons
    }*/
}

struct WeatherModel: Codable {
    var weatherDescription: String?
    var weatherName: String?
    var temperature: Int?
    var weatherIcon: String?
    var observationDate: String?
    var observationTime: String?
    
    init(data: WeatherRowData) {
        weatherDescription = "Description" + data.currentWeather.weatherDescription
        weatherName = data.currentLocation.name
        temperature = data.currentWeather.temperature
        weatherIcon = data.currentWeather.weatherIcon
        observationDate = data.currentLocation.localTime
        observationTime = data.currentWeather.observationTime
    }
}

struct ErrorModel: Decodable {
    let status: Bool?
    let error: ErrorData?
    
    enum CodingKeys: String, CodingKey {
        case status = "success"
        case error
    }
    
    struct ErrorData: Decodable {
        let code: Int?
        let type: String?
        let info: String?
    }
}
