//
//  ApiClientTests.swift
//  WeatherAPiTests
//
//  Created by Gayan Dias on 29/07/2024.
//

import XCTest
import Combine
@testable import WeatherAPi

/*
final class ApiClientTests: XCTestCase {
    
    var cancelable = Set<AnyCancellable>()
    
    struct TestModel: Codable {
        let id: Int
        let title: String
    }
    
    private func setMockProtocol() {
        MockURLProtocol.requestHandler = { request in
            let exampleData =
                """
                {"id":-1009,"title":"Hello, world!"}
                """
                .data(using: .utf8)!
            let response = HTTPURLResponse.init(url: request.url!, statusCode: 200, httpVersion: "2.0", headerFields: nil)!
            print("++++++++++++++++++++++++++++++++++ \(response)")
            return (response, exampleData)
        }
    }
    
    func testAsyncRequest() async throws {
        
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: sessionConfiguration)
        //setMockProtocol()
        
        let apiClient = NetworkManager(session: session)
        let endpoint = MockEndpoint()
        let request = RequestModel(endPoint: endpoint, method: .get)
        
        let expectation = XCTestExpectation(description: "Request failed.")
        
        let result = await apiClient.request(request, responseModel: TestModel.self)
        
        result.sink { result in
            switch result {
                case .finished:
                    break
                case .failure:
                    expectation.fulfill()
            }
        } receiveValue: { value in
            expectation.fulfill()
            print("******************************* \(value.id)")
            print(value.title)
            XCTFail("Request successful")
            XCTAssertEqual(value.id, -1009)
            XCTAssertEqual(value.title, "Hello, world!")
        }.store(in: &cancelable)
        //await(for: [expectation], timeout: 5)
    }
}*/

class HttpClientTest: XCTestCase, Mockable {
    
    private var cancelable: Set<AnyCancellable> = []
    private var urlSession: URLSession!
    private var httpClient: APIClient!
    private let httpRequestURL = URL(string: "http://api.weatherstack.com/current?access_key=d207fbf0c9b345a0c23bb5066b7bea54&query=New%20york")!
    private let soapRequestURL = URL(string: "https://www.w3.org/2003/05/soap-envelope/")!
    private let unsupportedRequestURL = URL(string: "ht://www.w3.org/2003/05/soap-envelope/")!
    private let herder: [String: String] = ["Content-Type": "application/json"]
    
    override func setUpWithError() throws {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: config)
        httpClient = NetworkManager(session: urlSession)
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        urlSession = nil
        httpClient = nil
        cancelable.forEach {$0.cancel()}
        cancelable.removeAll()
        try super.tearDownWithError()
    }
    
    private func hTTPUrlResponse(with code: Int) -> HTTPURLResponse {
        return HTTPURLResponse(url: httpRequestURL,
                               statusCode: code,
                               httpVersion: nil,
                               headerFields: herder)!
    }
    
    private func mockDatas() -> Data {
        let mockString =
        """
        {"id":12345,"title":"Hello, world!"}
        """
        let mockData: Data = Data(mockString.utf8)
        return mockData
    }
    
    private func mockDataWithError() -> Data {
        let mockString =
        """
        [{"ids":12345,"titles":"Hello, world!"}'
        """
        let mockData: Data = Data(mockString.utf8)
        return mockData
    }
    
//    private func mockSoapResponse() -> Data {
//        let mockSoapResponse =
//        """
//        <?xml version="1.0"?>
//
//        <soap:Envelope
//        xmlns:soap="http://www.w3.org/2003/05/soap-envelope"
//        soap:encodingStyle="http://www.w3.org/2003/05/soap-encoding">
//          ...
//          Message information goes here
//          ...
//        </soap:Envelope>
//        """
//        let mockData: Data = Data(mockSoapResponse.utf8)
//        return mockData
//    }
    
    /*func test_WeatherApi_return_TransportError() async throws {
        let response = hTTPUrlResponse(with: -1002)
        MockURLProtocol.requestHandler = { request in
            return (response, self.mockDatas())
        }
        
        let request = RequestModel(endPoint: MockEndpoint(), method: .get)
        let expectation = XCTestExpectation(description: "Error Response")
        
        await httpClient.request(request, responseModel: TestModel.self)
            .sink { result in
                switch result {
                    case .finished:
                    break
                    case .failure(let error):
                    XCTAssertEqual(.unSupportedUrl(response.statusCode), error)
                        expectation.fulfill()
                }
            } receiveValue: { value in
                //print(value.id)
            }.store(in: &cancelable)
        await fulfillment(of: [expectation], timeout: 5)
    }*/
    
    func test_WeatherApi_return_Success() async throws {
        MockURLProtocol.requestHandler = { request in
            return (self.hTTPUrlResponse(with: 200), self.mockDatas())
        }
        
        let request = RequestModel(endPoint: MockEndpoint(), method: .get)
        let expectation = XCTestExpectation(description: "Success Response")
        
        await httpClient.request(request, responseModel: TestModel.self)
        .sink { result in
        } receiveValue: { value in
            XCTAssertEqual(value.id, 12345)
            XCTAssertEqual(value.title, "Hello, world!")
            expectation.fulfill()
        }.store(in: &cancelable)
        await fulfillment(of: [expectation], timeout: 5)
    }
    
    
    func test_WeatherApi_return_BadResponse_Error() async throws {
        let response = hTTPUrlResponse(with: 400)
        MockURLProtocol.requestHandler = { request in
            return (response, self.mockDatas())
        }
        
        let request = RequestModel(endPoint: MockEndpoint(), method: .get)
        let expectation = XCTestExpectation(description: "BadResponse Error")
        
        await httpClient.request(request, responseModel: TestModel.self)
        .sink { result in
            switch result {
                case .finished:break
                case .failure(let error):
                    XCTAssertEqual(.badRequest(response.statusCode), error)
                    expectation.fulfill()
            }
        } receiveValue: { value in
        }.store(in: &cancelable)
        await fulfillment(of: [expectation], timeout: 7)
    }
    
    func test_WeatherApi_return_Unauthorised_Error() async throws {
        let response = hTTPUrlResponse(with: 401)
        MockURLProtocol.requestHandler = { request in
            return (response, self.mockDatas())
        }
        
        let request = RequestModel(endPoint: MockEndpoint(), method: .get)
        let expectation = XCTestExpectation(description: "Unauthorised Error")
        
        await httpClient.request(request, responseModel: TestModel.self)
        .sink { result in
            switch result {
                case .finished:break
                case .failure(let error):
                    XCTAssertEqual(NetworkRequestError.unauthorised(response.statusCode), error)
                    expectation.fulfill()
            }
        } receiveValue: { value in
        }.store(in: &cancelable)
        await fulfillment(of: [expectation], timeout: 5)
    }
    
    func test_WeatherApi_return_NotFound_Error() async throws {
        let response = hTTPUrlResponse(with: 404)
        MockURLProtocol.requestHandler = { request in
            return (response, self.mockDatas())
        }
        
        let request = RequestModel(endPoint: MockEndpoint(), method: .get)
        let expectation = XCTestExpectation(description: "NotFound Error")
        
        await httpClient.request(request, responseModel: TestModel.self)
        .sink { result in
            switch result {
                case .finished:break
                case .failure(let error):
                    XCTAssertEqual(NetworkRequestError.notFound(response.statusCode), error)
                    expectation.fulfill()
            }
        } receiveValue: { value in
        }.store(in: &cancelable)
        await fulfillment(of: [expectation], timeout: 5)
    }
    
    func test_WeatherApi_return_Forbidden_Error() async throws {
        let response = hTTPUrlResponse(with: 403)
        MockURLProtocol.requestHandler = { request in
            return (response, self.mockDatas())
        }
        
        let request = RequestModel(endPoint: MockEndpoint(), method: .get)
        let expectation = XCTestExpectation(description: "Forbidden Error")
        
        await httpClient.request(request, responseModel: TestModel.self)
        .sink { result in
            switch result {
                case .finished:break
                case .failure(let error):
                    XCTAssertEqual(NetworkRequestError.forbidden(response.statusCode), error)
                    expectation.fulfill()
            }
        } receiveValue: { value in
        }.store(in: &cancelable)
        await fulfillment(of: [expectation], timeout: 5)
    }
    
    func test_WeatherApi_return_API_Error() async throws {
        let response = hTTPUrlResponse(with: 200)
        MockURLProtocol.requestHandler = { request in
            return (response, self.mockDatas())
        }
        
        let request = RequestModel(endPoint: MockEndpoint(), method: .get)
        let expectation = XCTestExpectation(description: "Api Error")
        
        await httpClient.request(request, responseModel: TestDecodingErrorModel.self)
        .sink { result in
            switch result {
                case .finished:break
                case .failure(let error):
                    XCTAssertEqual(NetworkRequestError.apiError(error.localizedDescription), error)
                    expectation.fulfill()
            }
        } receiveValue: { value in
        }.store(in: &cancelable)
        await fulfillment(of: [expectation], timeout: 5)
    }
    
    func test_WeatherApi_return_Decoding_Error() async throws {
        let response = hTTPUrlResponse(with: 200)
        MockURLProtocol.requestHandler = { request in
            return (response, self.mockDataWithError())
        }
        
        let request = RequestModel(endPoint: MockEndpoint(), method: .get)
        let expectation = XCTestExpectation(description: "Decoding Error")
        
        await httpClient.request(request, responseModel: TestModel.self)
        .sink { result in
            switch result {
                case .finished:break
                case .failure(let error):
                XCTAssertEqual(NetworkRequestError.decodingError(error.localizedDescription), error)
                    expectation.fulfill()
            }
        } receiveValue: { value in
        }.store(in: &cancelable)
        await fulfillment(of: [expectation], timeout: 5)
    }
}

struct TestModel: Codable {
    let id: Int
    let title: String
}

struct TestDecodingErrorModel: Codable {
    let name: String
    let isEnter: Bool
}