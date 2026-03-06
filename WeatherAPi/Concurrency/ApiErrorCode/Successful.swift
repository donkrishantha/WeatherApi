//
//  InformationalResponse.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 03/03/2026.
//

import Foundation

/// Successful API response
enum Successful: Error, Equatable, HTTPStatus {
    case ok
    case created
    case accepted
    case nonAuthoritativeInformation
    case noContent
    case resetContent
    case partialContent
    case multiStatus
    case alreadyReported
    case imUsed
    case unknown(Int)
    
    init(code: Int) {
        switch code {
        case 200: self = .ok
        case 201: self = .created
        case 202: self = .accepted
        case 203: self = .nonAuthoritativeInformation
        case 204: self = .noContent
        case 205: self = .resetContent
        case 206: self = .partialContent
        case 207: self = .multiStatus
        case 208: self = .alreadyReported
        case 226: self = .imUsed
        default: self = .unknown(code)
        }
    }
    
    var statusCode: Int {
        switch self {
        case .ok: return 200
        case .created: return 201
        case .accepted: return 202
        case .nonAuthoritativeInformation: return 203
        case .noContent: return 204
        case .resetContent: return 205
        case .partialContent: return 206
        case .multiStatus: return 207
        case .alreadyReported: return 208
        case .imUsed: return 226
        case .unknown(let code):
            return code
        }
    }
    
    var description: String {
        switch self {
        case .ok: return "OK"
        case .created: return "Created"
        case .accepted: return "Accepted"
        case .nonAuthoritativeInformation: return "Non-Authoritative Information"
        case .noContent: return "No Content"
        case .resetContent: return "Reset Content"
        case .partialContent: return "Partial Content"
        case .multiStatus: return "Multi-Status"
        case .alreadyReported: return "Already Reported"
        case .imUsed: return "IM Used"
        case .unknown(let code): return "Unknown Success code: \(code)"
        }
    }
}
