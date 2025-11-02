//
//  TMDB.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 01/11/2025.
//

import Foundation

struct TMDBErrorModel: Decodable {
    var status_code: Int
    var status_message: String
    var success: Bool
}

struct TMDBModel: Codable {
    let avatar: Avatar
    let id: Int
    let iso_639_1: String
    let iso_3166_1: String
    let name: String
    let include_adult: Bool
    let username: String
    
}

struct Avatar: Codable {
    let gravatar: Gravatar
    //let tmdb: Tmdb
}

struct Gravatar: Codable {
    let hash: String
}

struct Tmdb: Codable {
    let avatar_path: String
}
//
//{
//    "avatar": {
//        "gravatar": {
//            "hash": "15667d2f88de526984e747dbeb71af25"
//        },
//        "tmdb": {
//            "avatar_path": null
//        }
//    },
//    "id": 11737776,
//    "iso_639_1": "en",
//    "iso_3166_1": "NL",
//    "name": "",
//    "include_adult": false,
//    "username": "GayanDias"
//}
