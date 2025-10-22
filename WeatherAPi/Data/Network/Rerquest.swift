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

public struct RequestModel {
    var endPoint: EndpointProvider
    var method: HTTPMethod
    var body: Data?
    let requestTimeout: Float?
    var multipart: MultipartRequest2?
    
    /// GET
    init(endPoint: EndpointProvider,
         method: HTTPMethod,
         reqBody: Data? = nil,
         reqTimeout: Float? =  nil) {
        self.endPoint = endPoint
        self.method = method
        self.body = reqBody
        self.requestTimeout = reqTimeout
    }
    
    /// POST
    init(endPoint: EndpointProvider,
         method: HTTPMethod,
         reqBody: Data,
         reqTimeout: Float? =  nil) {
        self.endPoint = endPoint
        self.method = method
        self.body = reqBody
        self.requestTimeout = reqTimeout
    }
    
    func asURLRequest() throws -> URLRequest? {
        guard let url = try endPoint.getUrl() else {
            throw ApiError.apiError("Define error")
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("true", forHTTPHeaderField: "X-Use-Cache")
        
        /// post request body
        if let body = body {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                throw  ApiError.encodingError("Error encoding http body")
            }
        }
        
        /// image upload
        if let multipart = multipart {
            urlRequest.setValue(multipart.headerValue, forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("\(multipart.length)", forHTTPHeaderField: "Content-Length")
            urlRequest.httpBody = multipart.httpBody
        }
        
        return urlRequest
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
func asURLRequest() throws -> URLRequest? {
//        guard let url = endPoint.getUrl() else {
//            debugPrint("URL not found")
//            //return URLRequest(url: URL(string: "http.kkljk.")!)
//            throw ApiError2(errorCode: "ERROR-0", message: "URL error")
//        }
    
    guard let url = try endPoint.getNewUrl() else {
        debugPrint("URL not found")
        throw ApiError2(errorCode: "ERROR-0", message: "URL error")
    }
    
   // var urlComponents = URLComponents()
//        urlComponents.scheme = endPoint.scheme
//        urlComponents.host =  endPoint.baseURL
//        urlComponents.path = endPoint.path
//        if let queryItems = endPoint.queryItems {
//            urlComponents.queryItems = queryItems
//        }
            
//        guard let url = urlComponents.url else {
//            throw ApiError2(errorCode: "ERROR-0", message: "URL error")
//        }
    
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = method.rawValue
    urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
    urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
    urlRequest.addValue("true", forHTTPHeaderField: "X-Use-Cache")
    
    if let body = body {
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            throw ApiError2(errorCode: "ERROR-0", message: "Error encoding http body")
        }
    }
    return urlRequest
}
*/

/*
func getUrlRequest() -> URLRequest? {
    guard let url = endPoint.getUrl() else {
        debugPrint("URL not found")
        return nil
    }
    debugPrint("URL: \(url)")
    /// create request
    var request: URLRequest = URLRequest(url: url)
    //https://api.weatherstack.com/current/?access_key=d207fbf0c9b345a0c23bb5066b7bea54&query=New%20York"

    /// Define method
    request.httpMethod = endPoint.method.rawValue

    /* /// Add header
    for header in endPoint.headers {
        request.addValue(header.values, forHTTPHeaderField: header.keys)
    }*/
    let randomError = URLRequest(url: URL(string: "https://httpstat.us/random/200,201,500-504")!)
    let error400 = URLRequest(url: URL(string: "https://www.domain.com/support/kb/404_not_found_error/")!)
    let error300 = URLRequest(url: URL(string: "https://httpbin.org/status/300")!)
    return request
}*/

/*
protocol RequestModelProtocol {
    var endPoint: EndpointProvider { get }
    var method: HTTPMethod { get }
    var body: Data?  { get }
    var requestTimeout: Float?  { get }
    var multipart: MultipartRequest2? { get }
}

public struct RequestModel1: RequestModelProtocol {
    var endPoint: any EndpointProvider
    var method: HTTPMethod
    var body: Data?
    var requestTimeout: Float?
    var multipart: MultipartRequest2?

    
    /// GET
    init(endPoint: EndpointProvider,
         method: HTTPMethod,
         reqBody: Data? = nil,
         reqTimeout: Float? =  nil) {
        self.endPoint = endPoint
        self.method = method
        self.body = reqBody
        self.requestTimeout = reqTimeout
    }
    
    /// POST
    init(endPoint: EndpointProvider,
         method: HTTPMethod,
         reqBody: Data,
         reqTimeout: Float? =  nil) {
        self.endPoint = endPoint
        self.method = method
        self.body = reqBody
        self.requestTimeout = reqTimeout
    }
    
    func asURLRequest() throws -> URLRequest? {
        guard let url = try endPoint.getNewUrl() else {
            throw ApiError.apiError("Define error")
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("true", forHTTPHeaderField: "X-Use-Cache")
        
        /// post request
        if let body = body {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                throw  ApiError.encodingError("Error encoding http body")
            }
        }
        
        /// image upload
        if let multipart = multipart {
            urlRequest.setValue(multipart.headerValue, forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("\(multipart.length)", forHTTPHeaderField: "Content-Length")
            urlRequest.httpBody = multipart.httpBody
        }
        
        return urlRequest
    }
}*/
