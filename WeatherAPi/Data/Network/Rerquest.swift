//
//  Rerquest.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 25/01/2024.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

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
    init(_ method: HTTPMethod,
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
    
    public func asURLRequest() throws -> URLRequest {
        // Create URL request
        var request = URLRequest(url: try endPoint.asURL())
        
        // Add HTTP method
        request.httpMethod = method.rawValue
        
        // Add HTTP headers
        request.allHTTPHeaderFields = endPoint.header
        
        // Add request time out
        request.timeoutInterval = endPoint.requestTimeout ?? AppConstants.TimeInterval.value
        
//        if !endPoint.token!.isEmpty {
//            request.addValue("Bearer \(endPoint.token ?? "")", forHTTPHeaderField: "Authorization")
//        }
        
        //let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
//        let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
//        // Convert JSON data to a string for printing or further use
//        if let jsonString = String(data: jsonData, encoding: .utf8) {
//            print(jsonString)
//        }
        
        /// Add post request body
        if let body = body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
                //JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch {
                throw  ApiError.encodingError("Error encoding http body")
            }
        }
        /*
         if let body = body {
         //             request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
         //         }
         */
        
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

struct AnyEncodable: Encodable {

    private var encodable: Encodable

    init(_ encodable: Encodable) {
        self.encodable = encodable
    }

    func encode(to encoder: Encoder) throws {
        try encodable.encode(to: encoder)
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
/*
if let queryParams = queryParams {
    if method == .GET {
        // For GET requests, append query parameters to the URL
        
        var queryItems: [URLQueryItem] = []
        for (key, value) in queryParams {
            let queryItem = URLQueryItem(name: key, value: String(describing: value))
            queryItems.append(queryItem)
        }
        components.queryItems = queryItems
        request.url = components.url
        
    } else {
        // For other methods, add query parameters to the request body
        
        do {
            let data = try JSONSerialization.data(withJSONObject: queryParams)
            request.httpBody = data
        } catch {
            print(error.localizedDescription)
        }
        
    }
}
 
 //Add multipart form data
//        if let multipartFormData = endPoint.multipartFormData {
//            let boundary = "Boundary-\(UUID().uuidString)"
//            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//            for formData in multipartFormData {
//                request.httpBody?.append("--\(boundary)\r\n".data(using: .utf8)!)
//                request.httpBody?.append("Content-Disposition: form-data; name=\"\(formData.name)\"; filename=\"\(formData.filename)\"\r\n".data(using: .utf8)!)
//                request.httpBody?.append("Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!)
//                request.httpBody?.append(formData.data)
//                request.httpBody?.append("\r\n".data(using: .utf8)!)
//            }
//        }
 
 if let queryParams = self.queryParams {
     let queryItems = queryParams.map({URLQueryItem(name: $0.key, value: $0.value)})
     urlComponents.queryItems = queryItems
 }
 
 if let pathParams = self.pathParams {
     for param in pathParams {
         urlComponents.path.replace(param.key, with: param.value)
     }
 }
 
 /*
 let req: URLRequest = URLRequest(url: <#T##URL#>,
                                  cachePolicy: .reloadIgnoringLocalCacheData,
                                  timeoutInterval: requestTimeout ?? 1.0)
 
 guard var components = URLComponents(url: endPoint.baseURL, resolvingAgainstBaseURL: true) else {
     throw EndpointError.invalidBaseUrl
 }
 
 /// Add path
 components.path = endPoint.path
 //let url = endPoint.baseURL.appendingPathComponent(endPoint.path) //http://api.weatherstack.com/current
 
 //Add queryParams
 if let queryItems = endPoint.queryItems {
     components.queryItems = queryItems
 }

 /// Create request
 guard let url = components.url else {
     throw EndpointError.invalidURL
 }*/
 
 */
