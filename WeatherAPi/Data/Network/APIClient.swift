//
//  NetworkManager.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 16/01/2024.
//

import Foundation
import Combine
import OSLog

/// https://medium.com/@c64midi/modern-generic-network-layer-with-swift-concurrency-async-await-and-combine-part-2-2840fff77106
 protocol APIClientProtocol2 {
    
    // MARK: Request
    
    func request2<T: Codable & Sendable>(_ request: RequestModel2<Any>,
                             responseModel: T.Type?) async -> AnyPublisher<T, ApiError2>
    
    // MARK: Upload
    
    func upload2<T: Codable>(_ request: RequestModel2<Any>,
                            responseModel: T.Type) async -> AnyPublisher<T, ApiError2>
}

final class APIClient2: APIClientProtocol2 {
    
    private let session: URLSession
    private let logger = Logger.apiClient
    
    init(session: URLSession) {
        self.session = session
    }
    
    public convenience init() {
        let configuration = URLSessionConfiguration.default
        // Cash policy
        //configuration.requestCachePolicy = .useProtocolCachePolicy
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 300
        // Allow both WiFi and cellular access
        configuration.allowsCellularAccess = true
        // Allow network access even when the system considers it expensive
        configuration.allowsExpensiveNetworkAccess = true
        // Allow network access when the user has enabled Low Data Mode
        configuration.allowsConstrainedNetworkAccess = true
        self.init(session: URLSession(configuration: configuration))
    }
    
    // MARK: Request
    
    func request2<T: Codable>(_ request: RequestModel2<Any>,
                             responseModel: T.Type?) async -> AnyPublisher<T, ApiError2> {
        return session
            .dataTaskPublisher(for: try! request.asURLRequest())
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .mapError { error in
                self.logger.error("NETWORK MANAGER: \(error.localizedDescription)")
                self.logger.log(level: .error, "APIClient: \(error.localizedDescription)")
                return .transportError(error.localizedDescription, error.code.rawValue) //-1009
            }
            //.print()
            .retry(1)
            .flatMap { output -> AnyPublisher<T, ApiError2> in
                self.manageResponse(data: output.data, response: output.response)
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: Upload
    
    func upload2<T: Codable>(_ request: RequestModel2<Any>,
                            responseModel: T.Type) async -> AnyPublisher<T, ApiError2> {
        return session
            .dataTaskPublisher(for: try! request.asURLRequest())
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .mapError { error in
                self.logger.log(level: .error, "APIClient: \(error.localizedDescription)")
                return .transportError(error.localizedDescription, error.code.rawValue) //-1009
            }
            //.print()
            .retry(1)
            .flatMap { output -> AnyPublisher<T, ApiError2> in
                self.manageResponse(data: output.data, response: output.response)
            }
            .eraseToAnyPublisher()
    }
}

extension APIClient2 {
    private func manageResponse<T: Codable>(data: Data, response: URLResponse) -> AnyPublisher<T, ApiError2> {
        guard let response = response as? HTTPURLResponse else {
            #if DEBUG
            logger.log(level: .error, "APIClient: Response not valid")
            #endif
            return Fail(error: .invalidResponse(error: "Response not valid"))
                .eraseToAnyPublisher()
        }
        
        switch response.statusCode {
        case 200..<300:
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601
            return Just(data)
                .decode(type: T.self, decoder: jsonDecoder)
                .mapError { error in
                    do {
                        let apiError = try jsonDecoder.decode(ErrorModel.self, from: data)
                        #if DEBUG
                        self.logger.error("NETWORK MANAGER: \(apiError.error?.info ?? error.localizedDescription)")
                        self.logger.error("Decode failed: \(error)\nData result: \(String(describing: String(data: data, encoding: String.Encoding.utf8)))")
                        #endif
                        return .apiError(apiError.error?.info ?? error.localizedDescription)
                    } catch {
                        #if DEBUG
                        print("‼️", error)
                        self.logger.error("NETWORK MANAGER: \(error.localizedDescription)")
                        #endif
                        return .decodingError(error.localizedDescription)
                    }
                }
                .map {$0}
                .eraseToAnyPublisher()
        default:
            #if DEBUG
            self.logger.error("NETWORK MANAGER: \(response.statusCode)")
            #endif
            return Fail(error: self.httpErrorHandel(response.statusCode))
                .eraseToAnyPublisher()
        }
    }
    
    /// Parses a HTTP StatusCode and returns a proper error
    /// - Parameter statusCode: HTTP status code
    /// - Returns: Mapped Error
    
    private func httpErrorHandel(_ statusCode: Int) -> ApiError2 {
        switch statusCode {
        case 400:
            return .badRequest(statusCode)
        case 401:
            return .unauthorised(statusCode)
        case 403:
            return .forbidden(statusCode)
        case 404:
            return .notFound(statusCode)
        case 408:
            return .requestTimeout(statusCode)
        case 402, 405...499:
            return .error4xx(statusCode)
        case 500:
            return .serverError(statusCode)
        case 501...599:
            return .error5xx(statusCode)
        default:
            return .unknownError(statusCode)
        }
    }
}
