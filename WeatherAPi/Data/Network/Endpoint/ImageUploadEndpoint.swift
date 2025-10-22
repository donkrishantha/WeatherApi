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
    case createPassword(password: Password)
    case updateUserProfile(userName: String?, file: Data?)
    
    var path: String {
        switch self {
        case .checkUserVerify:
            return "/client/v4/user/tokens/verify"
        case .uploadImage(fileString: _, file: _):
            return "/api/v1/files/upload"
        case .createPassword(password: _):
            return "/password"
        case .updateUserProfile(userName: _, file: _):
            return "/api/v2/user"
        }
    }

    var body: [String : Any]? {
        switch self {
        case .checkUserVerify:
            return nil
        case .uploadImage(fileString: _, file: _):
            return nil
        case .createPassword(password: let password):
            return password.toDictionary
        case .updateUserProfile(userName: _, file: _):
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
    
    internal var mockFile: String? {
        switch self {
            
        case .checkUserVerify:
            return "mock_weather_detail"
        case .uploadImage(fileString: _, file: _):
            return "mock_weather_detail"
        case .createPassword(password: _):
            return "mock_weather_detail"
        case .updateUserProfile(userName: _, file: _):
            return "mock_weather_detail"
        }
    }
}

extension Encodable {
    
    internal var toDictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}

struct Password: Encodable {
    let password: String
}
