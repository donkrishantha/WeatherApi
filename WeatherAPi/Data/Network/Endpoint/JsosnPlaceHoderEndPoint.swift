//
//  JsosnPlaceHoderEndPoint.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 02/11/2025.
//

import Foundation

enum JsonPlaceHolderEndpoint: EndpointProvider {
    
    case postWebRequest
    case putWebRequest
    case patchWebRequest
    
    var path: String {
        
        switch self {
        case .postWebRequest:
            return "/posts"
        case .putWebRequest:
            return "/posts/1"
        case .patchWebRequest:
            return "/posts/1"
        }
    }
    
}
