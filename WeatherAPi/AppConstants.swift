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
