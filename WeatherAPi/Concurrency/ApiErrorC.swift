//
//  ApiError2C.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 01/03/2026.
//

import Foundation

/// HTTP error code and description

protocol HTTPStatus {
    var statusCode: Int { get }
    var description: String { get }
}

/// The main orchestrator service that unifies all HTTP response categories.
/// It simplifies error handling by wrapping specific groups into associated values.

enum APIError2: Error, Equatable, HTTPStatus {
    case informationResponse(Informational)
    case successfulResponse(Successful)
    case redirectionMessages(Redirection)
    case clientErrorResponses(ClientError)
    case serverErrorResponses(ServerError)
    case unknownError(_ status: Int)
    case badRequest(codeError: NSURLError)

    /// Handles system-level URL errors,
    /// Automatically categorises the response based on the HTTP status code range.
    init(urlResponse: HTTPURLResponse) {
        let statusCode = urlResponse.statusCode
        switch statusCode {
        case 100..<199:
            self = .informationResponse(Informational(code: statusCode))
        case 200..<299:
            self = .successfulResponse(Successful(code: statusCode))
        case 300..<399:
            self = .redirectionMessages(Redirection(code: statusCode))
        case 400..<499:
            self = .clientErrorResponses(ClientError(code: statusCode))
        case 500..<599:
            self = .serverErrorResponses(ServerError(code: statusCode))
        default:
            self = .unknownError(statusCode)
        }
    }
}

extension APIError2 {
    /// Compares two responses based on their numeric status codes.
    static func == (lhs: APIError2, rhs: APIError2) -> Bool {
        return lhs.statusCode == rhs.statusCode }
    
    /// HTTP status code
    var statusCode: Int {
        switch self {
        case .informationResponse(let code): return code.statusCode
        case .successfulResponse(let code): return code.statusCode
        case .redirectionMessages(let code): return code.statusCode
        case .clientErrorResponses(let code): return code.statusCode
        case .serverErrorResponses(let code): return code.statusCode
        case .unknownError(let code): return code
        case .badRequest(let codeError): return codeError.statusCode
        }
    }
    
    /// HTTP status description
    var description: String {
        switch self {
        case .informationResponse(let code): return "Informational: \(code.description)"
        case .successfulResponse(let code): return "Success: \(code.description)"
        case .redirectionMessages(let code): return "Redirection: \(code.description)"
        case .clientErrorResponses(let code): return "Client Error: \(code.description)"
        case .serverErrorResponses(let code): return "Server Error: \(code.description)"
        case .unknownError(let code): return "Unknown Status Code: \(code)"
        case .badRequest(let code): return "Bad System Request: \(code.description)"
        }
    }
    
    //case AFError.responseValidationFailed(.unacceptableStatusCode(let statusCode)) where statusCode == 401:
    //case AFError.responseValidationFailed(.unacceptableStatusCode(let statusCode)) where statusCode == 403:
    
    /// Safely unwraps the successful status if the response was a success.
    var successfulStatus: Successful? {
        if case .successfulResponse(let status) = self {
            return status
        }
        return nil
    }

    /// Safely unwraps the client error if the request was malformed or unauthorised.
    var clientError: ClientError? {
        if case .clientErrorResponses(let status) = self {
            return status
        }
        return nil
    }
}
