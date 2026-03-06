//
//  InformationalResponse.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 03/03/2026.
//

import Foundation

// 3xx Redirection: Further action needs to be taken by the user agent to fulfil the request.
enum Redirection: Error, HTTPStatus {
    case useProxy
    case found
    case seeOther
    case notModified
    case useProxyForAuthentication
    case temporaryRedirect
    case permanentRedirect
    case unknown(Int)
    
    init(code: Int) {
        switch code {
        case 300: self = .useProxy
        case 302: self = .found
        case 303: self = .seeOther
        case 304: self = .notModified
        case 305: self = .useProxyForAuthentication
        case 307: self = .temporaryRedirect
        case 308: self = .permanentRedirect
        default: self = .unknown(code)
        }
    }
    
    var statusCode: Int {
        switch self {
        case .useProxy: return 300
        case .found: return 302
        case .seeOther: return 303
        case .notModified: return 304
        case .useProxyForAuthentication: return 305
        case .temporaryRedirect: return 307
        case .permanentRedirect: return 308
        case .unknown(let code): return code
        }
    }
    
    var description: String {
        switch self {
        case .useProxy: return "Multiple Choices"
        case .found: return "Found"
        case .seeOther: return "See Other"
        case .notModified: return "Not Modified"
        case .useProxyForAuthentication: return "Use Proxy"
        case .temporaryRedirect: return "Temporary Redirect"
        case .permanentRedirect: return "Permanent Redirect"
        case .unknown(let code): return "Unknown Redirection code: \(code)"
        }
    }
}
