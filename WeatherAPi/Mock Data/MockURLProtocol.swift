//
//  MockURLProtocol.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 09/07/2024.
//

import Foundation
import Combine

//enum FileExtensionType: String {
//    case json = ".json"
//}
//
//protocol Mockable: AnyObject {
//    var bundle: Bundle { get }
//    func loadJSON<T: Decodable>(filename: String, extensionType: FileExtensionType, type: T.Type) -> T
//}
//
//extension Mockable {
//    var bundle: Bundle {
//        return Bundle(for: type(of: self))
//    }
//
//    func loadJSON<T: Decodable>(filename: String,
//                                extensionType: FileExtensionType,
//                                type: T.Type) -> T {
//        
////        let path1 = Bundle.main.path(forResource: "mock_weather_detail", ofType: "json")!
////        let url = URL(fileURLWithPath: path1)
//        
//        guard let path = bundle.url(forResource: "mock_weather_details", withExtension: "json") else {
//            fatalError("Failed to load JSON")
//            //XCTAssert(false, "Can't get data from sample.json")
//        }
//
//        do {
//            let data = try Data(contentsOf: path)
//            let decodedObject = try JSONDecoder().decode(type, from: data)
//
//            return decodedObject
//        } catch {
//            fatalError("Failed to decode loaded JSON")
//        }
//    }
//}

//class MockApiClient: Mockable, APIClientProtocol {
//    
//    var sendError: Bool
//    var mockFile: String?
//    
//    init(sendError: Bool = false, mockFile: String? = nil) {
//        self.sendError = sendError
//        self.mockFile = mockFile
//    }
//    
//    func asyncRequest<T>(endpoint: EndpointProvider, responseModel: T.Type) async throws -> T where T: Decodable {
//        if sendError {
//            throw ApiError.invalidResponse(error: "Response not valid")
//        } else {
//            let filename = mockFile ?? endpoint.mockFile!
//            return loadJSON(filename: filename, extensionType: .json, type: responseModel.self)
//        }
//    }
//    
//    func request<T: Codable>(_ request: RequestModel, responseModel: T.Type?) async -> AnyPublisher<T, ApiError> {
//        if sendError {
//            return Fail(error: ApiError.invalidResponse(error: "Response not valid"))
//                .eraseToAnyPublisher()
//        } else {
//            return Just(loadJSON(filename: request.endPoint.mockFile!, extensionType: .json, type: responseModel.self!) as T)
//                .setFailureType(to: ApiError.self)
//                .eraseToAnyPublisher()
//        }
//    }
//}


///-----------------------------------------------------
//class MockURLProtocol: URLProtocol {
//    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
//    
//    override class func canInit(with request: URLRequest) -> Bool {
//        return true
//    }
//    
//    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
//        return request
//    }
//    
//    override func stopLoading() { }
//    
//    override func startLoading() {
//         guard let handler = MockURLProtocol.requestHandler else {
//            return
//        }
//        
//        do {
//            let (response, data)  = try handler(request)
//            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
//            client?.urlProtocol(self, didLoad: data)
//            client?.urlProtocolDidFinishLoading(self)
//        } catch  {
//            client?.urlProtocol(self, didFailWithError: error)
//        }
//    }
//}

struct MockEndpoint: EndpointProvider2 {
    var header: [String : String]?
    
    //var body: Data?
    
    
    var scheme: String = "https"
    var baseURL: String = "api.weatherstack.com"
    var path: String = "/current"
    var method: HTTPMethod = .get
    var queryItems: [URLQueryItem]? = nil
    var body: [String: Any]? = nil
    var mockFile: String? = nil
}

//struct MockRequestModel1: EventsEndpoints {
//    var endPoint: EndpointProvider
//    var method: HTTPMethod = .get
//    var body: Data?
//    var requestTimeout: Float?
//    var multipart: MultipartRequest2?
//}
