//
//  File.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 08/07/2024.
//

import Foundation
import UIKit

extension URL {

    static var settings: URL {
        URL(string: UIApplication.openSettingsURLString)!
    }

    static var WeatherApi: URL {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "api.weatherstack.com"//Bundle.main.infoDictionary?["WEATHER_API_HOST"] as? String
        print(components.url!) // http://api.weatherstack.com
        return components.url!
    }
}
