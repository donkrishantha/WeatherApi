//
//  ApiClient-C.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 26/02/2026.
//

import Foundation

typealias apiResponse<T: Codable> = Result<T?, APIError2>

protocol ApiClientCProtocol {
    
    @available(iOS 13.0, *)
    @discardableResult
    func request2<T: Codable>(_ request: RequestModel3<Any>,
                              responseModel: T.Type?) async throws -> apiResponse<T>
}

final class ApiClientC: ApiClientCProtocol {

    private let session: URLSession
    
    public init(session: URLSession) {
        self.session = session
    }
    
    convenience init() {
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
    
    @available(iOS 13.0, *)
    @discardableResult
    func request2<T: Codable>(_ request: RequestModel3<Any>,
                              responseModel: T.Type?) async throws -> apiResponse<T> {
        do {
            let (data, response) = try await session.data(for: request.asURLRequest())
            return try self.manageResponse(data: data, response: response)
        } catch let error as URLError {
            /// Map low-level system errors to our structured NSURLErrorCode
            switch error.code {
            case .badURL:
                throw APIError2.badRequest(codeError: .badURL)
            case .timedOut:
                throw APIError2.badRequest(codeError: .timedOut)
            default:
                throw APIError2.badRequest(codeError: .unknown)
            }
        } catch {
            throw APIError2.badRequest(codeError: .unknown)
        }
    }
    
    private func manageResponse<T: Decodable>(data: Data, response: URLResponse) throws -> apiResponse<T> {
        /// Stage 2: Validate the HTTP protocol response
        guard let response = response as? HTTPURLResponse else {
            throw APIError2.badRequest(codeError: .invalidResponse)
        }
        
        let responseStatus = APIError2(urlResponse: response)
        
        /// Stage 3: Handle the categorised result
        switch responseStatus {
        case .successfulResponse:
            do {
                /// Only attempt decoding if the server returned a 2xx status
                let result = try JSONDecoder().decode(T.self, from: data)
                return result as! apiResponse
            } catch {
                ///? Wrap decoding failures as a specific badRequest subtype
                throw APIError2.badRequest(codeError: .decodingError)
            } default:
            /// Automatically throw 1xx, 3xx, 4xx, or 5xx errors
            throw responseStatus
        }
    }
}


