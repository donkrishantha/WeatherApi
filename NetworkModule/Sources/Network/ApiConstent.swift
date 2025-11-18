//
//  File.swift
//  Network
//
//  Created by Gayan Dias on 17/11/2025.
//

import Foundation
import OSLog
import Combine

/// API parameters
internal enum Environment {
    nonisolated(unsafe) private static let infoDic: [String: Any] = {
        guard let dic =  Bundle.main.infoDictionary else {
            fatalError("Plist is not found")
        }
        return dic
    }()
    
    static let baseUrl: URL = {
        guard let urlString = Environment.infoDic["WEATHER_API_HOST"] as? String else {
            fatalError("BASE_ URL is not found")
        }
        
        guard let url = URL(string: urlString) else {
            fatalError("ROOT_URL is invalid")
        }
        return url
    }()
    
    static let apiKy: String = {
        guard let key = Environment.infoDic["API_KEY"] as? String else {
            fatalError("API_KEY is not found")
        }
        return key
    }()
}

/// HTTPS method type
public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}


/// API constants parameters
enum APIConstants {
    enum TimeInterval {
        static let value: Double = 60
    }
    
    enum HeaderParameterType {
        static let json: String = "application/json"
    }
}

struct ErrorModel: Decodable {
    let status: Bool?
    let error: ErrorData?

    enum CodingKeys: String, CodingKey {
        case status = "success"
        case error
    }

    struct ErrorData: Decodable {
        let code: Int?
        let type: String?
        let info: String?
    }
}


//extension Optional {
//    var isNil: Bool { self == nil }
//    var isNotNil: Bool { self != nil }
//}


//extension Optional where Wrapped: Numeric & Comparable {
//    var isNilOrZero:Bool { return self == nil && self == 0 }
//}

//extension Optional {
//    func or(_ defaultValue: Wrapped) -> Wrapped {
//        self ?? defaultValue
//    }
//}

//extension Encodable {
//    func toJSON() -> String? {
//        guard let data = try? JSONEncoder().encode(self) else { return nil }
//        return String(data: data, encoding: .utf8)
//    }
//}
