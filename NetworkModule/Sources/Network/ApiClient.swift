//
//  File.swift
//  Network
//
//  Created by Gayan Dias on 12/11/2025.
//

import Foundation
import Combine
import OSLog
///Command | Option | /

public typealias APIResponse<T> = AnyPublisher<T, APIError>

public protocol APIClientProtocol {
    
    // MARK: Request
    @available(iOS 13.0, *)
    @discardableResult
    func request<T: Codable>(_ request: RequestModel<Any>,
                             responseModel: T.Type?) async -> APIResponse<T>
    
    // MARK: Upload
    @available(iOS 13.0, *)
    @discardableResult
    func upload<T: Codable>(_ request: RequestModel<Any>,
                            responseModel: T.Type) async -> APIResponse<T>
}

@available(iOS 14.0, *)
public final class APIClient: APIClientProtocol {
    
    /// Session for the url request
    private let session: URLSession
    
    /// Api log ststes
    let logger = Logger.apiClient
    
    public init(session: URLSession) {
        self.session = session
    }
    
    /// URL configuration for addition requirements
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
    /// Make the api request
    /// - Parameters:
    ///   - request: RequestModel : -> all request parameters
    ///   - responseModel: response from the api
    /// - Returns: AnyPublisher<Codable, APIError>
    public func request<T: Codable>(_ request: RequestModel<Any>,
                             responseModel: T.Type?) async -> APIResponse<T> {
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
            .flatMap { output -> APIResponse<T> in
                self.manageResponse(data: output.data, response: output.response)
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: Upload
    /// Make the api request
    /// - Parameters:
    ///   - request: RequestModel : -> all request parameters
    ///   - responseModel: response from the api
    /// - Returns: AnyPublisher<Codable, APIError>
    public func upload<T: Codable>(_ request: RequestModel<Any>,
                            responseModel: T.Type) async -> APIResponse<T> {
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
            .flatMap { output -> APIResponse<T> in
                self.manageResponse(data: output.data, response: output.response)
            }
            .eraseToAnyPublisher()
    }
}
