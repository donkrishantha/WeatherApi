//
//  File.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 08/07/2024.
//

import Foundation
import UIKit

extension URL {

    static var WeatherApi: URL {
        var components = URLComponents()
        components.scheme = "http"
        components.host = Bundle.main.infoDictionary?["WEATHER_API_HOST"] as? String
        return components.url!
    }
    
    static var TMDBApi: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Bundle.main.infoDictionary?["TMDB_API_HOST"] as? String
        return components.url!
    }
}
