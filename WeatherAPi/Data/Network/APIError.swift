//
//  NertworkError.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 16/01/2024.
//

import UIKit
import Network

struct AlertMessage {
    let title: String?
    let message: String?
}

enum ApiError: Error, LocalizedError, Equatable {
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
    
    var errorDescription: String? {
        switch self {
        case .requestTimeout(let code):
            return "requestTimeout: \(code)"
        case .invalidRequest(statusCode: let statusCode): // 400
            return "InvalidRequest: \(statusCode)"
        case .invalidResponse(error: let error):
            return "InvalidResponse: \(error)"
        case .transportError(let error, let code):
            return "\(error): \(code)"
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
            return "\(_error)"
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

/*
do {
    let user = try JSONDecoder().decode(User.self, from: jsonData)
} catch let error as DecodingError {
    switch error {
    case .keyNotFound(let key, let context):
        let path = context.codingPath.map { $0.stringValue }.joined(separator: " -> ")
        print("Missing key '\(key.stringValue)' at path \(path), reason: \(context.debugDescription)")
    case .typeMismatch(let type, let context):
        let path = context.codingPath.map { $0.stringValue }.joined(separator: " -> ")
        print("Type '\(type)' mismatch at path \(path), reason: \(context.debugDescription)")
    case .valueNotFound(let type, let context):
        let path = context.codingPath.map { $0.stringValue }.joined(separator: " -> ")
        print("Value of type '\(type)' not found at path \(path), reason: \(context.debugDescription)")
    case .dataCorrupted(let context):
        let path = context.codingPath.map { $0.stringValue }.joined(separator: " -> ")
        print("Data corrupted at path \(path), reason: \(context.debugDescription)")
    @unknown default:
        print("Unknown decoding error: \(error.localizedDescription)")
    }
} catch {
    print("Another error occurred: \(error)")
}*/

struct ApiErrorNew: Error {
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

extension ApiErrorNew: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        errorCode = try container.decode(String.self, forKey: .errorCode)
        message = try container.decode(String.self, forKey: .message)
    }
}

enum HTTPHeader: String {
    case contentType = "Content-Type"
    case authorization = "Authorization"
}

enum ContentType: String {
    case json = "application/json"
    case xml = "application/xml"
    case formUrlEncoded = "application/x-www-form-urlencoded"
}

//100-level (Informational) – server acknowledges a request
//200-level (Success) – server completed the request as expected
//300-level (Redirection) – client needs to perform further actions to complete the request
//400-level (Client error) – client sent an invalid request
//500-level (Server error) – server failed to fulfill a valid request due to an error with server

//400 Bad Request – client sent an invalid request, such as lacking required request body or parameter
//401 Unauthorized – client failed to authenticate with the server
//403 Forbidden – client authenticated but does not have permission to access the requested resource
//404 Not Found – the requested resource does not exist
//412 Precondition Failed – one or more conditions in the request header fields evaluated to false
//500 Internal Server Error – a generic error occurred on the server
//503 Service Unavailable – the requested service is not available
//410 https://medium.com/@jacobmartinbartlett/async-testing-masterclass-2-mocking-like-a-pro-475bba9d25aa

//http://the-internet.herokuapp.com/status_codes/200
//http://the-internet.herokuapp.com/status_codes/301
//http://the-internet.herokuapp.com/status_codes/404
//http://the-internet.herokuapp.com/status_codes/500


/*
private func handleError(error: Error, errorModel: ErrorModel) -> ApiError {
    switch error {
    case is Swift.DecodingError:
        return .decodingError(_error: error.localizedDescription)
    case is Swift.EncodingError:
        return .encodingError(_error: error.localizedDescription)
    case is ApiError:
        return .decodingError(_error: error.localizedDescription)
    case _ as ApiError:
        return .urlSessionFailed("oo", 0)
    case let error as ApiError:
        return error
    default:
        return .unknownError(00)
    }
}*/

/*private func handleStatusCode(statusCode: Int) throws {
    switch statusCode {
    case 200 ..< 300:
        break
    case 400:
        throw APIError.httpError(.badRequest)
    case 401:
        throw APIError.httpError(.unauthorized)
    case 403:
        throw APIError.httpError(.forbidden)
    case 404:
        throw APIError.httpError(.notFound)
    case 500:
        throw APIError.httpError(.serverError)
    default:
        throw APIError.httpError(.unknown)
    }
}*/
