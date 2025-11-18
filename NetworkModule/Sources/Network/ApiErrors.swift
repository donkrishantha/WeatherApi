//
//  File.swift
//  Network
//
//  Created by Gayan Dias on 12/11/2025.
//

import UIKit

public enum APIError: Error, LocalizedError, Equatable {
    case requestTimeout(_ code: Int)
    case invalidRequest(_ code: Int) // 400
    case invalidResponse(error: String)
    case transportError(_ error: String, _ code: Int)
    case badRequest(_ code: Int) // 400
    case unauthorised(_ code: Int) // 401
    case forbidden(_ code: Int) // 403
    case notFound(_ code: Int) //404
    case error4xx(_ code: Int)
    case serverError(_ code: Int) // 500
    case error5xx(_ code: Int)
    case decodingError(_ error: String )
    case encodingError(_ error: String )
    case urlSessionFailed(String, Int)
    case apiError(_ error: String)
    case unknownError(_ code: Int)
    
    public var errorDescription: String? {
        switch self {
        case .requestTimeout(let code):
            return "requestTimeout: \(code)"
        case .invalidRequest(statusCode: let statusCode): // 400
            return "InvalidRequest: \(statusCode)"
        case .invalidResponse(error: let error):
            return "InvalidResponse: \(error)"
        case .transportError(let error, let code):
            return "TransportError: \(error): \(code)"
        case .badRequest(statusCode: let statusCode):
            return "BadRequest:  \(statusCode)"
        case .unauthorised(statusCode: let statusCode):
            return "Unauthorised:  \(statusCode)"
        case .forbidden(statusCode: let statusCode):
            return "Forbidden:  \(statusCode)"
        case .notFound(statusCode: let statusCode):
            return "NotFound:  \(statusCode)"
        case .error4xx(let code):
            return "Error4xx: \(code)"
        case .serverError(let code):
            return "ServerError: \(code)"
        case .error5xx(let code):
            return "Error5xx: \(code)"
        case .decodingError(_error: let _error):
            return "DecodingError: \(_error)"
        case .encodingError(_error: let _error):
            return "EncodingError: \(_error)"
        case .urlSessionFailed(let error, let code):
            return "UrlSessionFailed: \(error) \(code)"
        case .apiError(let error):
            return "\(error)"
        case .unknownError(let code):
            return "UnknownError: \(code)"
        
        }
    }
}

/// Parses a HTTP StatusCode and returns a proper error
/// - Parameter statusCode: HTTP status code
/// - Returns: Mapped Error
///
func httpError(_ statusCode: Int) throws -> APIError {
    switch statusCode {
    case 400:
        throw APIError.badRequest(statusCode)
    case 401:
        throw APIError.unauthorised(statusCode)
    case 403:
        throw APIError.forbidden(statusCode)
    case 404:
        throw APIError.notFound(statusCode)
    case 408:
        throw APIError.requestTimeout(statusCode)
    case 402, 405...499:
        throw APIError.error4xx(statusCode)
    case 500:
        throw APIError.serverError(statusCode)
    case 501...599:
        throw APIError.serverError(statusCode)
    default:
        throw APIError.unknownError(statusCode)
    }
}
