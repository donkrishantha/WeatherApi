//
//  InformationalResponse.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 03/03/2026.
//

import Foundation

//// Informational Responses, which indicate that the request was received and the process is continuing.
enum Informational: Error, HTTPStatus {
    case continueResponse
    case switchingProtocols
    case processingDeprecated
    case earlyHints
    case unknown(Int)
    
    init(code: Int) {
        switch code {
        case 100: self = .continueResponse
        case 101: self = .switchingProtocols
        case 102: self = .processingDeprecated
        case 103: self = .earlyHints
        default: self = .unknown(code)
        }
    }
    
    var statusCode: Int {
        switch self {
        case .continueResponse: return 100
        case .switchingProtocols: return 101
        case .processingDeprecated: return 102
        case .earlyHints: return 103
        case .unknown(let code): return code
        }
    }
    
    var description: String {
        switch self {
        case .continueResponse: return "Continue"
        case .switchingProtocols: return "Switching Protocols"
        case .processingDeprecated: return "Processing"
        case .earlyHints: return "Early Hints"
        case .unknown(let code): return "Unknown code: \(code)"
        }
    }
}
