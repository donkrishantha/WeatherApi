//
//  File.swift
//  Network
//
//  Created by Gayan Dias on 12/11/2025.
//

import Foundation

/// API request parameters for url request
public struct RequestModel<Parameters>: URLRequestConvertible {
    
    private var method: HTTPMethod
    private var endPoint: EndpointProvider
    private var body: Parameters?
    private var headers: Headers?
    private let requestTimeout: TimeInterval?
    //private var multipart: MultipartRequest2?
    
    public typealias Parameters = [String: Any]
    public typealias Headers = [String: String]

    /// GET
    public init(_ method: HTTPMethod,
         _ endPoint: EndpointProvider,
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
        _ endPoint: EndpointProvider,
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
                throw  APIError.encodingError("Error encoding http body")
            }
        }
        
        return request
    }
}

/// Types adopting the `URLRequestConvertible` protocol can be used to safely construct `URLRequest`s.
public protocol URLRequestConvertible {
    /// Returns a `URLRequest` or throws if an `Error` was encountered.
    ///
    /// - Returns: A `URLRequest`.
    /// - Throws:  Any error thrown while constructing the `URLRequest`.
    func asURLRequest() throws -> URLRequest
}

/// <#Description#>
struct AnyEncodable: Encodable {

    private var encodable: Encodable

    init(_ encodable: Encodable) {
        self.encodable = encodable
    }

    func encode(to encoder: Encoder) throws {
        try encodable.encode(to: encoder)
    }
}

