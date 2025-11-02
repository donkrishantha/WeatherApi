//
//  TMDBEndpoint.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 01/11/2025.
//

import Foundation

enum TMDBEndPoint: EndpointProvider {
    
    case getTMDBDetails(accountId: Int)
    
    var path: String {
        switch self {
        case .getTMDBDetails(accountId: let accountId):
            return "/account/\(accountId)"
        }
    }
    
}
