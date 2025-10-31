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
        //request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Bearer \(token ?? "")": "Authorization"
        ]
        return headers
    }
    
    var multipartFormData: [(name: String, filename: String, data: Data)]? {
        return nil
    }
    
    var token: String? {
        //return ApiConfig.shared.token?.value ?? ""
        return "nil"
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
