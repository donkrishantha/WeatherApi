//
//  NSURLErrorCode.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 03/03/2026.
//

import Foundation

/// Handle  low-level network issues using the exact same pattern as our HTTP responses.
enum NSURLError: Error, HTTPStatus {
    case unknown
    case invalidResponse
    case badURL
    case timedOut
    case decodingError
    case outOfRange(Int)
    
    init(code: Int) {
        switch code {
        case 0: self = .unknown
        case 1: self = .invalidResponse
        case 2: self = .badURL
        case 3: self = .timedOut
        case 4: self = .decodingError
        default: self = .outOfRange(code)
        }
    }
    
    var statusCode: Int {
        switch self {
        case .unknown: return 0
        case .invalidResponse: return 1
        case .badURL: return 2
        case .timedOut: return 3
        case .decodingError: return 4
        case .outOfRange(let code): return code
        }
    }
    
    var description: String {
        switch self {
        case .unknown: return "An unknown error occurred."
        case .invalidResponse: return "Invalid response"
        case .badURL: return "The URL was malformed."
        case .timedOut: return "The request timed out."
        case .decodingError: return "Failed to decode the response."
        case .outOfRange(let statusCode): return "The request \(statusCode) was out of range."
        }
    }
}
