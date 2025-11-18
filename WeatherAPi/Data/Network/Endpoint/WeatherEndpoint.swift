//
//  WeatherEndpoint.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 16/01/2024.
//

import Foundation
import Combine
import Network

enum EventsEndpoints: EndpointProvider {
   
    case getCurrentWeatherDetails(query: String)
    case getWeatherDetails(id: Int)
    case updateUserProfile(userName: String?, file: Data?)
    
    internal var path: String {
        switch self {
        case .getCurrentWeatherDetails(query: _):
            return "/current"
        case .getWeatherDetails(id: let id):
            return "/users/\(id)"
        case .updateUserProfile:
            return "/api/v2/user"
        }
    }
    
    internal var queryItems: [URLQueryItem]? {
        switch self {
        case .getCurrentWeatherDetails(let query):
            return [URLQueryItem(name: AppConstants.QueryKey.apiKey.rawValue, value: Environment.apiKy),
                    URLQueryItem(name: AppConstants.QueryKey.searchString.rawValue, value: String(query))]
        default:
            return nil
        }
    }
    
//    internal var header: [String: String]? {
//        // Access Token to use in Bearer header
//        let accessToken = "insert your access token here -> https://www.themoviedb.org/settings/api"
//        switch self {
//        case .topRated, .movieDetail:
//            return [
//                "Authorization": "Bearer \(accessToken)",
//                "Content-Type": "application/json;charset=utf-8"
//            ]
//        }
//    }
// // Set up any request headers or parameters here
    //endpoint.headers?.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
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
