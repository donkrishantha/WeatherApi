//
//  ImageUploadEndpoint.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 10/09/2024.
//

import Foundation

enum ImageUploadEndpoint: EndpointProvider {
    
    case checkUserVerify
    case uploadImage(fileString: String?, file: Data?)
    
    var path: String {
        switch self {
        case .checkUserVerify:
            return "/client/v4/user/tokens/verify"
        case .uploadImage(fileString: _, file: _):
            return "/api/v1/files/upload"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .checkUserVerify:
            .get
        case .uploadImage(fileString: _, file: _):
            .post
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .checkUserVerify:
            return nil
        case .uploadImage(fileString: _, file: _):
            return nil
        }
    }
    
    var body: [String : Any]? {
        switch self {
        case .checkUserVerify:
            return nil
        case .uploadImage(fileString: _, file: _):
            return nil
        }
    }
    
    var mockFile: String? {
        switch self {
        case .checkUserVerify:
            return nil
        case .uploadImage(fileString: _, file: _):
            return nil
        }
    }
    
    var multipart: MultipartRequest2? {
        switch self {
        case .uploadImage(fileString: let fileString, file: let file):
            let multipart = MultipartRequest2()
            if let preferredName = fileString {
                multipart.append(fileString: preferredName, withName: "preferredName")
            }
            if let file = file {
                multipart.append(fileData: file, withName: "profilePicture", fileName: "profilePicture.jpg", mimeType: .jpeg)
            }
            return multipart
        default :
            return nil
        }
    }
}
