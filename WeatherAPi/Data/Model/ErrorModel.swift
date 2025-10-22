//
//  ErrorModel.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 22/10/2025.
//

import Foundation

struct ErrorModel: Decodable {
    let status: Bool?
    let error: ErrorData?

    enum CodingKeys: String, CodingKey {
        case status = "success"
        case error
    }

    struct ErrorData: Decodable {
        let code: Int?
        let type: String?
        let info: String?
    }
}
