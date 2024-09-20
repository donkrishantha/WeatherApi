//
//  AppConstants.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 18/04/2024.
//

import Foundation

enum AppConstants {
    
    enum Api {
        static let baseUrl = "http://api.weatherstack.com"
        static let apiKey = "d207fbf0c9b345a0c23bb5066b7bea54"
    }
    
    enum QueryKey: String {
        case apiKey = "access_key"
        case searchString = "query"

        // Weather Query
        case numOfDays = "num_of_days"
        case forcast = "fx"
        case currentCondition = "cc"
        case monthlyCondition = "mca"
        case location = "includelocation"
        case comments = "show_comments"
        case tp = "tp"
    }
    
    enum Response: String {
        case json = "application/json"
    }
}

enum Environment {
    
    private static let infoDic: [String: Any] = {
        guard let dic =  Bundle.main.infoDictionary else {
            fatalError("Plist is not found")
        }
        return dic
    }()
    
    static let baseUrl: URL = {
        guard let urlString = Environment.infoDic["WEATHER_API_HOST"] as? String else {
            fatalError("BASE_ URL is not found")
        }
        
        guard let url = URL(string: urlString) else {
            fatalError("ROOT_URL is invalid")
        }
        return url
    }()
    
    static let apiKy: String = {
        guard let key = Environment.infoDic["API_KEY"] as? String else {
            fatalError("API_KEY is not found")
        }
        return key
    }()
}
