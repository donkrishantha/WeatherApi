//
//  MockURLProtocol.swift
//  WeatherAPiTests
//
//  Created by Gayan Dias on 04/08/2024.
//

import XCTest
@testable import WeatherAPi

/// https://medium.com/@mctok/testing-network-layer-in-swift-53e34b62f70c
class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (URLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func stopLoading() { }
    
    override func startLoading() {
         guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("No handler set")
            return
        }
        
        do {
            let (response, data)  = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch  {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
}
