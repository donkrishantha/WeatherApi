//
//  NertworkError.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 16/01/2024.
//

import UIKit
//import Reachability
import Network

struct AlertMessage {
    let title: String
    let message: String
}

struct ClientError: Error, Codable {
    let success: Bool
    let ErrorData: ErrorData?
    
    struct ErrorData: Error, Codable {
        let code: Int?
        let type: String?
        let info: String?
    }
}

/*
enum APIError: Error {
    /// Invalid request, e.g. invalid URL
    case invalidRequestError(String)
    
    /// Indicates an error on the transport layer, e.g. not being able to connect to the server
    case transportError(Error)
    
    /// Received an invalid response, e.g. non-HTTP result
    case invalidResponse
    
    /// Server-side validation error
    case validationError(String)
    
    /// The server sent data in an unexpected format
    /// Indicates failure in decoding the response data into the expected type.
    case decodingError(String)
    
    /// The server sent data in an unexpected format
    case encodingError(error: Error)
    
    /// Bad HTTP response
    case badResponse(statusCode: Int)
    
    /// client sent an invalid request - 400
    case clientError(statusCode: Int, reason: String)
    
    /// Server return error - 500
    case serverError(statusCode: Int, reason: String)
    
    var errorDescription: String? {
        switch self {
        case .invalidRequestError(let message):
            return "Invalid request: \(message)"
        case .transportError(let error):
            return "Transport error: \(error)"
        case .invalidResponse:
            return "Invalid response"
        case .validationError(let reason):
            return "Validation Error: \(reason)"
        case .decodingError(let reason):
            return "\(reason)"
        case .badResponse(statusCode: let statusCode):
            return "Bad Response Code: \(statusCode)"
        case .serverError(statusCode: let statusCode, reason: let reason):
            return "Server Error with code \(statusCode), reason \(reason)"
        case .encodingError:
            return "Failed to encode the object from the service"
        case .clientError(statusCode: let statusCode, reason: let reason):
            return "\(reason): with \(statusCode)"
        }
    }
}*/

enum NetworkRequestError: Error, LocalizedError, Equatable {
    case requestTimeout(_ code: Int)
    /// Invalid request, e.g. invalid URL
    case invalidRequest(_ code: Int) // 400
    /// Received an invalid response, e.g. non-HTTP result
    case invalidResponse(error: String)
    /// Indicates an error on the transport layer, e.g. not being able to connect to the server
    case transportError(_ error: String)
    case badRequest(_ code: Int) // 400
    case unauthorised(_ code: Int) // 401
    case forbidden(_ code: Int) // 403
    /// Indicates that the requested resource was not found (HTTP 404).
    case notFound(_ code: Int) //404
    case error4xx(_ code: Int)
    case serverError(_ code: Int) // 500
    case error5xx(_ code: Int)
    /// Represents a failure in decoding the response data, encapsulating the decoding error.
    case decodingError(_ error: String )
    /// Represents a failure in encoding the request parameters, encapsulating the encoding error.
    case encodingError(_ error: String )
    case urlSessionFailed(String, Int)
    case apiError(_ error: String)
    case unSupportedUrl(_ code: Int)
    case unknownError(_ code: Int)
    
    var errorDescription: String? {
        switch self {
        case .requestTimeout(let code):
            return "requestTimeout: \(code)"
        case .invalidRequest(statusCode: let statusCode): // 400
            return "InvalidRequest: \(statusCode)"
        case .invalidResponse(error: let error):
            return "InvalidResponse: \(error)"
        case .transportError(let error):
            return "\(error)"
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
            //return "DecodingError: \(_error)"
            return "\(_error)"
        case .encodingError(_error: let _error):
            return "EncodingError: \(_error)"
        case .urlSessionFailed(let error, let code):
            return "UrlSessionFailed: \(error) \(code)"
        case .apiError(let error):
            return "\(error)"
        case .unSupportedUrl(let error):
            return "\(error)"
        case .unknownError(let code):
            return "UnknownError: \(code)"
        
        }
    }
}
//--------------------------------------------------------------

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

//---------------------------------------------------------------

/*
public enum NetworkError: Error, LocalizedError {
    
    case missingRequiredFields(String)
    
    case invalidParameters(operation: String, parameters: [Any])
    
    case badRequest
    
    case unauthorized
    
    case paymentRequired
    
    case forbidden
    
    case notFound
    
    case requestEntityTooLarge
    
    case unprocessableEntity
    
    case http(httpResponse: HTTPURLResponse, data: Data)
    
    case invalidResponse(Data)
    
    case deleteOperationFailed(String)
    
    case network(URLError)
    
    case unknown(Error?)
}*/

enum HTTPHeader: String {
    case contentType = "Content-Type"
    case authorization = "Authorization"
}

enum ContentType: String {
    case json = "application/json"
    case xml = "application/xml"
    case formUrlEncoded = "application/x-www-form-urlencoded"
}

public class NetworkReachability {

    var pathMonitor: NWPathMonitor!
    var path: NWPath?
    lazy var pathUpdateHandler: ((NWPath) -> Void) = { path in
        self.path = path
        if path.status == NWPath.Status.satisfied {
            print("Connected")
        } else if path.status == NWPath.Status.unsatisfied {
            print("unsatisfied")
        } else if path.status == NWPath.Status.requiresConnection {
            print("requiresConnection")
        }
    }

    let backgroudQueue = DispatchQueue.global(qos: .background)

    init() {
        pathMonitor = NWPathMonitor()
        pathMonitor.pathUpdateHandler = self.pathUpdateHandler
        pathMonitor.start(queue: backgroudQueue)
    }

    func isNetworkAvailable() -> Bool {
        if let path = self.path {
            if path.status == NWPath.Status.satisfied {
                return true
            }
        }
        return false
    }
}


final class NetworkMonitor: ObservableObject {
    static let shared = NetworkMonitor()
    let queue = DispatchQueue(label: "NetworkMonitor")
    let monitor = NWPathMonitor()
    @Published public private(set) var isConnected: Bool = false
    private var hasStatus: Bool = false
    
    init() {
        monitor.pathUpdateHandler = { path in
            #if targetEnvironment(simulator)
                if (!self.hasStatus) {
                    self.isConnected = path.status == .satisfied
                    self.hasStatus = true
                } else {
                    self.isConnected = !self.isConnected
                }
            #else
                self.isConnected = path.status == .satisfied
            #endif
            print("isConnected: " + String(self.isConnected))
        }
        monitor.start(queue: queue)
    }
}

class NetworkStatus: ObservableObject {
    static let shared = NetworkStatus()
    private var monitor: NWPathMonitor?
    private var queue = DispatchQueue(label: "NetworkMonitor")
    @Published var isConnected: Bool = false

    private init() {
        monitor = NWPathMonitor()
        startMonitoring()
    }

    deinit {
        stopMonitoring()
    }
    
    func startMonitoring() {
        monitor?.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                let status = path.status == .satisfied
                self?.isConnected = status
                print(">>> \(path.status)")
            }
        }

        monitor?.start(queue: queue)
    }

    func stopMonitoring() {
        monitor?.cancel()
        monitor = nil
    }
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

//http://the-internet.herokuapp.com/status_codes/200
//http://the-internet.herokuapp.com/status_codes/301
//http://the-internet.herokuapp.com/status_codes/404
//http://the-internet.herokuapp.com/status_codes/500
