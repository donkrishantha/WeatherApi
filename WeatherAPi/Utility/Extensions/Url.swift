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
        print(components.url!)
        return components.url!
    }
}

enum DemoEnvironment {
    private static let infoDict: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist is not found")
        }
        return dict
    }()
    
    static let rootURL: URL = {
        guard let urlString = DemoEnvironment.infoDict["GO_SHARING_API_HOST"] as? String else {
            fatalError ("Root_URL is not found" )
        }
        
        guard let url = URL(string: urlString) else {
            fatalError ("Root_URL is invalid")
        }
        return url
    }()
    
    static let apiKey: String = {
        guard let apiKey = DemoEnvironment.infoDict["API_KEY"] as? String else {
            fatalError("plist is not found")
        }
        return apiKey
    }()
}
