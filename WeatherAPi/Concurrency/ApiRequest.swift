
//
//  File.swift
//  Network
//
//  Created by Gayan Dias on 12/11/2025.
//

import Foundation

enum EncodingError: Error {
    case error(_ : String)
}

/// API request parameters for url request
struct RequestModel3<Parameters>: URLRequestConvertible {
    
    private var method: HTTPMethod
    private var endPoint: EndpointProvider3
    private var body: Parameters?
    private var headers: Headers?
    private let requestTimeout: TimeInterval?
    //private var multipart: MultipartRequest2?
    
    public typealias Parameters = [String: Any]
    public typealias Headers = [String: String]

    /// GET
    init(_ method: HTTPMethod,
         _ endPoint: EndpointProvider3,
         with parameters: Parameters? = nil,
         headers: Headers? = nil,
         reqTimeout: TimeInterval? =  nil
    )where Parameters == Parameters {
        self.endPoint = endPoint
        self.method = method
        self.body = parameters
        self.headers = headers
        self.requestTimeout = reqTimeout
    }
    
    /// POST
    init<T: Encodable>(
        _ method: HTTPMethod,
        _ endPoint: EndpointProvider3,
        with parameters: T,
        headers: Headers? = nil,
        reqTimeout: TimeInterval? =  nil
    ) where Parameters == AnyEncodable {
        self.endPoint = endPoint
        self.method = method
        self.body = AnyEncodable(parameters)
        self.headers = headers
        self.requestTimeout = reqTimeout
    }
    
    /// Url request for making api call
    /// - Returns: URLRequest
    public func asURLRequest() throws -> URLRequest {
        // Create URL request
        var request = URLRequest(url: try endPoint.asURL())
        
        // Add HTTP method
        request.httpMethod = method.rawValue
        
        // Add HTTP headers
        request.allHTTPHeaderFields = endPoint.header
        
        // Add request time out
        request.timeoutInterval = endPoint.requestTimeout ?? APIConstants.TimeInterval.value
        
        /// Add post request body
        if let body = body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
                //JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch {
                //throw  APIError2.encodingError("Error encoding http body")
                throw EncodingError.error("Error encoding http body")
            }
        }
        
        return request
    }
}

/// Types adopting the `URLRequestConvertible` protocol can be used to safely construct `URLRequest`s.
//public protocol URLRequestConvertible {
//    /// Returns a `URLRequest` or throws if an `Error` was encountered.
//    ///
//    /// - Returns: A `URLRequest`.
//    /// - Throws:  Any error thrown while constructing the `URLRequest`.
//    func asURLRequest() throws -> URLRequest
//}

/// <#Description#>
//struct AnyEncodable: Encodable {
//
//    private var encodable: Encodable
//
//    init(_ encodable: Encodable) {
//        self.encodable = encodable
//    }
//
//    func encode(to encoder: Encoder) throws {
//        try encodable.encode(to: encoder)
//    }
//}

//============================================
//
//  File.swift
//  Network
//
//  Created by Gayan Dias on 12/11/2025.
//

//import Foundation
//
////enum EndpointError: Error {
////    case invalidURL
////    case invalidBaseUrl
////}
//
//protocol EndpointProvider: URLConvertible {
//    var baseURL: URL { get }
//    var path: String { get }
//    var queryItems: [URLQueryItem]? { get }
//    var mockFile: String? { get }
//    var header: [String: String]? { get }
//    var token: String? { get }
//    var requestTimeout: TimeInterval? { get }
//    var multipartFormData: [(name: String, filename: String, data: Data)]? { get }
//}
//
//extension EndpointProvider {
//    var baseURL: URL {
//        return .Jsonplaceholder
//    }
//    
//    var queryItems: [URLQueryItem]? {
//        return nil
//    }
//
//    var mockFile: String? {
//        return nil
//    }
//    
//    var header: [String: String]? {
//        let headers = [
//            "Content-Type": APIConstants.HeaderParameterType.json,
//            "Accept": APIConstants.HeaderParameterType.json,
//            "Authorization": "Bearer " + Environment.apiKy
//        ]
//        /* TMDB http header
//         let headers = [
//            "Content-Type": "application/json",
//            "Accept": "application/json",
//            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlNGFiNTcxM2ZjZWFiYWQ1MWYyZTg3N2E3NzU0OWUzOCIsIm5iZiI6MTY0MTg5NzY4MC40MzM5OTk4LCJzdWIiOiI2MWRkNWVkMDFkNmM1ZjAwMWJmZjJmMTciLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.BF25FTUljDa81WHUsIdBvmpR_Y_1OuMf2D3PVeT9mgs"
//        ]*/
//        return headers
//    }
//    
//    var multipartFormData: [(name: String, filename: String, data: Data)]? {
//        return nil
//    }
//    
//    var token: String? {
//        //return ApiConfig.shared.token?.value ?? ""
//        return "nil"
//    }
//    
//    var requestTimeout: TimeInterval? {
//        return 60
//    }
//    
//    /// Returns a `URL` from the conforming instance or throws.
//    ///
//    /// - Returns: The `URL` created from the instance.
//    /// - Throws:  Any error thrown while creating the `URL`.
//    func asURL() throws -> URL {
//        let url = baseURL.appendingPathComponent(path)
//        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
//        components?.queryItems = queryItems
//        guard let url = components?.url else {
//            throw EndpointError.invalidURL
//        }
//        print(url)
//        return url
//    }
//}

//public protocol URLConvertible {
//    /// Returns a `URL` from the conforming instance or throws.
//    ///
//    /// - Returns: The `URL` created from the instance.
//    /// - Throws:  Any error thrown while creating the `URL`.
//    func asURL() throws -> URL
//}
//
