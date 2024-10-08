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
    case createPassword(password: Password)
    case updateUserProfile(userName: String?, file: Data?)
    
    internal var path: String {
        switch self {
        case .getCurrentWeatherDetails(accessKey: _, query: _):
            return "/current"
        case .getWeatherDetails(id: let id):
            return "/users/\(id)"
        case .createPassword(password: _):
            return "/password"
        case .updateUserProfile:
            return "/api/v2/user"
        }
    }
    
    internal var method: HTTPMethod {
        switch self {
        case .getCurrentWeatherDetails(accessKey: _, query: _):
                .get
        case .getWeatherDetails(id: _):
                .put
        case .createPassword(password: _):
                .post
        case  .updateUserProfile:
                .post
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
    
    internal var body: [String: Any]? {
        switch self {
        case .getCurrentWeatherDetails, .getWeatherDetails:
            return nil
        case .createPassword(password: let password):
            return password.toDictionary
        case .updateUserProfile:
            return nil
        }
    }
    
    internal var mockFile: String? {
        switch self {
        case .getCurrentWeatherDetails(accessKey: _, query: _):
            return "mock_weather_detail"
        case .getWeatherDetails(id: _):
            return "_dismissEventMockResponse"
        default :
            return nil
        }
    }
    
    var multipart: MultipartRequest2? {
        switch self {
        case .updateUserProfile(let userName, let file):
            let multipart = MultipartRequest2()
            if let preferredName = userName {
                multipart.append(fileString: preferredName, withName: "preferredName")
            }
            if let file = file {
                multipart.append(fileData: file, withName: "profilePicture", fileName: "profilePicture.jpg", mimeType: .jpeg)
            }
            return multipart
        default :
            return nil
        }
    }
}

extension Encodable {
    
    internal var toDictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}

struct Password: Encodable {
    let password: String
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
