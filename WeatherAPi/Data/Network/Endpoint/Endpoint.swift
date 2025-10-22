//
//  APIEndpoint.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 16/01/2024.
//

import Foundation

enum EndpointError: Error {
    case invalidURL
}

protocol EndpointProvider {
    var baseURL: URL { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var body: [String: Any]? { get }
    var mockFile: String? { get }
    func getUrl() throws -> URL?
}

extension EndpointProvider {

    var baseURL: URL {
        return .WeatherApi
    }
    
    func getUrl() throws -> URL? {
        let url = baseURL.appendingPathComponent(path) //http://api.weatherstack.com/current
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = queryItems
        guard let url = components?.url else {
            throw EndpointError.invalidURL
        }
        return url
    }
}

/*
 protocol EndpointProvider {
     var baseURL: URL { get }
     var path: String { get }
     //var method: HTTPMethod { get }
     //var token: String { get }
     var queryItems: [URLQueryItem]? { get }
     var body: [String: Any]? { get }
     var mockFile: String? { get }
     //var uploadData: Data? { get }
     func getUrl() throws -> URL?
 }

 extension EndpointProvider {

     var baseURL: URL {
         return .WeatherApi
         //return URL(string: "http://api.weatherstack.com")!
         //return URL(fileURLWithPath: "api.weatherstack.com")
     }
     
     func getUrl() throws -> URL? {
         let url = baseURL.appendingPathComponent(path) //http://api.weatherstack.com/current
         var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
         components?.queryItems = queryItems
         guard let url = components?.url else {
             throw EndpointError.invalidURL
         }
         return url
     }
 }
 */

//enum HTTPMethod: String {
//    case get = "GET"
//    case post = "POST"
//    case put = "PUT"
//    case patch = "PATCH"
//    case delete = "DELETE"
//}

/*
struct ApiError2: Error {
    var statusCode: Int!
    let errorCode: String
    var message: String
    
    init(statusCode: Int = 0, errorCode: String, message: String) {
        self.statusCode = statusCode
        self.errorCode = errorCode
        self.message = message
    }
    
    var errorCodeNumber: String {
        let numberString = errorCode.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        return numberString
    }
    
    private enum CodingKeys: String, CodingKey {
        case errorCode
        case message
    }
}

extension ApiError2: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        errorCode = try container.decode(String.self, forKey: .errorCode)
        message = try container.decode(String.self, forKey: .message)
    }
}*/

/*
protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var parameter: [URLQueryItem]? { get }
    func getUrl() -> URL?
}

extension Endpoint {
    var scheme: String {
        return "http"
    }
    
    var host: String {
        return "api.weatherstack.com"
    }
    
    func getUrl() -> URL? {
        var component = URLComponents()
        component.scheme = scheme
        component.host = host
        component.path = path
        component.queryItems = parameter
        return component.url
    }
}*/

// Set up any request headers or parameters here
//endpoint.headers?.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }

/*
let sendableClosure = { @Sendable (number: Int) -> String in
    if number > 12 {
        return "More than a dozen."
    } else {
        return "Less than a dozen"
    }
}*/
