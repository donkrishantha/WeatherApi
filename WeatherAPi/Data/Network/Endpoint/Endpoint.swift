//
//  APIEndpoint.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 16/01/2024.
//

import Foundation

enum EndpointError: Error {
    case invalidURL
    case invalidBaseUrl
}

protocol EndpointProvider: URLConvertible {
    var baseURL: URL { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var mockFile: String? { get }
    var header: [String: String]? { get }
    var token: String? { get }
    var requestTimeout: TimeInterval? { get }
    var multipartFormData: [(name: String, filename: String, data: Data)]? { get }
}

extension EndpointProvider {
    var baseURL: URL {
        return .WeatherApi
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }

    var mockFile: String? {
        return nil
    }
    
    var header: [String: String]? {
        let headers = [
            "Content-Type": AppConstants.HeaderParameterType.json,
            "Accept": AppConstants.HeaderParameterType.json,
            "Authorization": "Bearer " + Environment.apiKy
        ]
        /* TMDB http header
         let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlNGFiNTcxM2ZjZWFiYWQ1MWYyZTg3N2E3NzU0OWUzOCIsIm5iZiI6MTY0MTg5NzY4MC40MzM5OTk4LCJzdWIiOiI2MWRkNWVkMDFkNmM1ZjAwMWJmZjJmMTciLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.BF25FTUljDa81WHUsIdBvmpR_Y_1OuMf2D3PVeT9mgs"
        ]*/
        return headers
    }
    
    var multipartFormData: [(name: String, filename: String, data: Data)]? {
        return nil
    }
    
    var token: String? {
        //return ApiConfig.shared.token?.value ?? ""
        return "nil"
    }
    
    var requestTimeout: TimeInterval? {
        return 60
    }
    
    func asURL() throws -> URL {
        let url = baseURL.appendingPathComponent(path)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = queryItems
        guard let url = components?.url else {
            throw EndpointError.invalidURL
        }
        return url
    }
}

protocol URLConvertible {
    /// Returns a `URL` from the conforming instance or throws.
    ///
    /// - Returns: The `URL` created from the instance.
    /// - Throws:  Any error thrown while creating the `URL`.
    func asURL() throws -> URL
}
