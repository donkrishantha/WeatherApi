//
//  WeatherEndpoint.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 16/01/2024.
//

import Foundation
import Combine

enum EventsEndpoints: EndpointProvider {
        
    case getCurrentWeatherDetails(accessKey: String, query: String)
    case getWeatherDetails(id: Int)
    case updateUserProfile(userName: String?, file: Data?)
    
    internal var path: String {
        switch self {
        case .getCurrentWeatherDetails(accessKey: _, query: _):
            return "/current"
        case .getWeatherDetails(id: let id):
            return "/users/\(id)"
        case .updateUserProfile:
            return "/api/v2/user"
        }
    }
    
    internal var queryItems: [URLQueryItem]? {
        switch self {
        case .getCurrentWeatherDetails(let accessKey, let query):
            return [URLQueryItem(name: AppConstants.QueryKey.apiKey.rawValue, value: "\(accessKey)"),
                    URLQueryItem(name: AppConstants.QueryKey.searchString.rawValue, value: "\(query)")]
        default:
            return nil
        }
    }
}


/*
enum WeatherEndpoint: Endpoint {
    
    case getCurrentWeatherDetails(accessKey: String, query: String)
    case getWeatherDetails(id: Int)
    
    private var requestTimeout: Float {
        return 20
    }
    
    internal var baseURL: URL {
        return URL(string: AppConstants.Api.baseUrl)!
    }
    
    internal var path: String {
        switch self {
        case .getCurrentWeatherDetails(_, _):
            return "/current"
        case .getWeatherDetails(let id):
            return "/users/\(id)"
        }
    }
    
    internal var method: HTTPMethod {
        switch self {
        case .getCurrentWeatherDetails:
            return .get
        case .getWeatherDetails:
            return .put
        }
    }
    
    internal var headers: [String: String] {
        switch self {
        case .getCurrentWeatherDetails, .getWeatherDetails:
            return ["Content-Type": AppConstants.Response.json.rawValue]
        }
    }
    
    internal var parameter: [URLQueryItem]? {
        switch self {
        case .getCurrentWeatherDetails(let accessKey, let query):
            let items = [URLQueryItem(name: AppConstants.QueryKey.apiKey.rawValue, value: "\(accessKey)"),
                         URLQueryItem(name: AppConstants.QueryKey.searchString.rawValue, value: "\(query)")]
            return items
        default:
            return nil
        }
    }
}*/
