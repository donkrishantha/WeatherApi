//
//  NetworkManager.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 16/01/2024.
//

import Foundation
import Combine
import OSLog

protocol APIClient {
    func request<T: Codable>(_ request: RequestModel, responseModel: T.Type?) async -> AnyPublisher<T, NetworkRequestError>
}

final class NetworkManager: APIClient {
    
    var session: URLSession
    private let logger = Logger.apiClient
    
    convenience init() {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 300
        self.init(session: URLSession(configuration: configuration))
    }
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func request<T: Codable>(_ request: RequestModel, responseModel: T.Type?) async -> AnyPublisher<T, NetworkRequestError> {
        return session
            .dataTaskPublisher(for: try! request.asURLRequest()!)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .mapError { error in
                self.logger.error("NETWORK MANAGER: \(error.localizedDescription)")
                return .transportError(error.localizedDescription, error.code.rawValue) //-1009
            }
            //.print()
            .retry(1)
            .flatMap { output -> AnyPublisher<T, NetworkRequestError> in
                self.manageResponse(data: output.data, response: output.response)
            }
            .eraseToAnyPublisher()
    }
    
    private func manageResponse<T: Codable>(data: Data, response: URLResponse)  -> AnyPublisher<T, NetworkRequestError> {
        guard let response = response as? HTTPURLResponse else {
            logger.error("NETWORK MANAGER: Response not valid")
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
                        self.logger.error("NETWORK MANAGER: \(apiError.error?.info ?? error.localizedDescription)")
                        return .apiError(apiError.error?.info ?? error.localizedDescription)
                    } catch {
                        self.logger.error("NETWORK MANAGER: \(error.localizedDescription)")
                        return .decodingError(error.localizedDescription)
                    }
                }
                .map {$0}
                .eraseToAnyPublisher()
        default:
            self.logger.error("NETWORK MANAGER: \(response.statusCode)")
            return Fail(error: self.httpErrorHandel(response.statusCode))
                .eraseToAnyPublisher()
        }
    }
    
    /// Parses a HTTP StatusCode and returns a proper error
    /// - Parameter statusCode: HTTP status code
    /// - Returns: Mapped Error
    
    private func httpErrorHandel(_ statusCode: Int) -> NetworkRequestError {
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
    
    /*
    private func handleError(error: Error, errorModel: ErrorModel) -> NetworkRequestError {
        switch error {
        case is Swift.DecodingError:
            return .decodingError(_error: error.localizedDescription)
        case is Swift.EncodingError:
            return .encodingError(_error: error.localizedDescription)
        case is NetworkRequestError:
            return .decodingError(_error: error.localizedDescription)
        case _ as NetworkRequestError:
            return .urlSessionFailed("oo", 0)
        case let error as NetworkRequestError:
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
}
