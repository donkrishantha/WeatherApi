//
//  File.swift
//  Network
//
//  Created by Gayan Dias on 18/11/2025.
//

import Foundation
import OSLog
import Combine

/// Extension for the making url request.
extension URL {
    static var WeatherApi: URL {
        var components = URLComponents()
        components.scheme = "http"
        components.host = Bundle.main.infoDictionary?["WEATHER_API_HOST"] as? String
        return components.url!
    }
    
    static var TMDBApi: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Bundle.main.infoDictionary?["TMDB_API_HOST"] as? String
        return components.url!
    }
    
    static var Jsonplaceholder: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Bundle.main.infoDictionary?["JSONPLACEHOLDER_API_HOST"] as? String
        return components.url!
    }
}

@available(iOS 14.0, *)
extension Logger {
    /// Using your bundle identifier is a great way to ensure a unique identifier.
    static let subsystem = Bundle.main.bundleIdentifier!
    
    /// Logs the view cycles like a view that appeared.
    static let viewCycle = Logger(subsystem: subsystem, category: "ViewCycle")
    
    static let fileLocation = Logger(subsystem: subsystem, category: "FileLocation")
    
    static let dataStore = Logger(subsystem: subsystem, category: "DataStore")
    
    static let fileManager = Logger(subsystem: subsystem, category: "FileManager")
    
    static let apiClient = Logger(subsystem: subsystem, category: "APIClient")
}

@available(iOS 14.0, *)
extension APIClient {
    /// Handel api response.
    /// - Parameters:
    ///   - data: HTTPS response
    ///   - response: URLResponse
    /// - Returns: AnyPublisher<Codable, APIError>
    func manageResponse<T: Codable>(data: Data, response: URLResponse) -> APIResponse<T> {
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
                    /*do {
                        let apiError = try jsonDecoder.decode(ErrorModel.self, from: data)
                        return .apiError(apiError.error?.info ?? error.localizedDescription)
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
                            
                            return .decodingError(error.localizedDescription)
                        }
                    } catch {
                        print("Another error occurred: \(error)")
                        return .decodingError(error.localizedDescription)
                    }
                    return .decodingError(error.localizedDescription)*/
                }
                .map {$0}
                .eraseToAnyPublisher()
        default:
            #if DEBUG
            self.logger.error("NETWORK MANAGER: \(response.statusCode)")
            #endif
            let apiError = try? httpError(response.statusCode)
            return Fail(error: apiError ?? APIError.unknownError(response.statusCode))
                .eraseToAnyPublisher()
        }
    }
}
