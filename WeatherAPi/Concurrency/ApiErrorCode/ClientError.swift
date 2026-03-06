//
//  InformationalResponse.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 03/03/2026.
//

import Foundation

/// 4xx Client Error: The request contains bad syntax or cannot be fulfilled.
enum ClientError: Error, HTTPStatus {
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case methodNotAllowed
    case notAcceptable
    case proxyAuthenticationRequired
    case requestTimeout
    case conflict
    case gone
    case lengthRequired
    case preconditionFailed
    case payloadTooLarge
    case URITooLong
    case unsupportedMediaType
    case rangeNotSatisfiable
    case expectationFailed
    case misdirectedRequest
    case unProcessableEntity
    case locked
    case failedDependency
    case upgradeRequired
    case preconditionRequired
    case tooManyRequests
    case requestHeaderFieldsTooLarge
    case unavailableForLegalReasons
    case unknown(Int)
    
    init(code: Int) {
        switch code {
        case 400: self = .badRequest
        case 401: self = .unauthorized
        case 403: self = .forbidden
        case 404: self = .notFound
        case 405: self = .methodNotAllowed
        case 406: self = .notAcceptable
        case 407: self = .proxyAuthenticationRequired
        case 408: self = .requestTimeout
        case 409: self = .conflict
        case 410: self = .gone
        case 411: self = .lengthRequired
        case 412: self = .preconditionFailed
        case 413: self = .payloadTooLarge
        case 414: self = .URITooLong
        case 415: self = .unsupportedMediaType
        case 416: self = .rangeNotSatisfiable
        case 417: self = .expectationFailed
        case 421: self = .misdirectedRequest
        case 422: self = .unProcessableEntity
        case 423: self = .locked
        case 424: self = .failedDependency
        case 426: self = .upgradeRequired
        case 428: self = .preconditionRequired
        case 429: self = .tooManyRequests
        case 431: self = .requestHeaderFieldsTooLarge
        case 451: self = .unavailableForLegalReasons
        default: self = .unknown(code)
        }
    }
    
    var statusCode: Int {
        switch self {
        case .badRequest: return 400
        case .unauthorized: return 401
        case .forbidden: return 403
        case .notFound: return 404
        case .methodNotAllowed: return 405
        case .notAcceptable: return 406
        case .proxyAuthenticationRequired: return 407
        case .requestTimeout: return 408
        case .conflict: return 409
        case .gone: return 410
        case .lengthRequired: return 411
        case .preconditionFailed: return 412
        case .payloadTooLarge: return 413
        case .URITooLong: return 414
        case .unsupportedMediaType: return 415
        case .rangeNotSatisfiable: return 416
        case .expectationFailed: return 417
        case .misdirectedRequest: return 421
        case .unProcessableEntity: return 422
        case .locked: return 423
        case .failedDependency: return 424
        case .upgradeRequired: return 426
        case .preconditionRequired: return 428
        case .tooManyRequests: return 429
        case .requestHeaderFieldsTooLarge: return 431
        case .unavailableForLegalReasons: return 451
        case .unknown(let code): return code
        }
    }
    
    var description: String {
        switch self {
        case .badRequest: return "Bad Request"
        case .unauthorized: return "Unauthorised"
        case .forbidden: return "Forbidden"
        case .notFound: return "Not Found"
        case .methodNotAllowed: return "Method Not Allowed"
        case .notAcceptable: return "Not Acceptable"
        case .proxyAuthenticationRequired: return "Proxy Authentication Required"
        case .requestTimeout: return "Request Timeout"
        case .conflict: return "Conflict"
        case .gone: return "Gone"
        case .lengthRequired: return "Length Required"
        case .preconditionFailed: return "Precondition Failed"
        case .payloadTooLarge: return "Payload Too Large"
        case .URITooLong: return "URI Too Long"
        case .unsupportedMediaType: return "Unsupported Media Type"
        case .rangeNotSatisfiable: return "Range Not Satisfiable"
        case .expectationFailed: return "Expectation Failed"
        case .misdirectedRequest: return "Misdirected Request"
        case .unProcessableEntity: return "Unprocurable Entity"
        case .locked: return "Locked"
        case .failedDependency: return "Failed Dependency"
        case .upgradeRequired: return "Upgrade Required"
        case .preconditionRequired: return "Precondition Required"
        case .tooManyRequests: return "Too Many Requests"
        case .requestHeaderFieldsTooLarge: return "Request Header Fields Too Large"
        case .unavailableForLegalReasons: return "Unavailable For Legal Reasons"
        case .unknown(let code): return "Unknown Client Error code: \(code)"
        }
    }
}
