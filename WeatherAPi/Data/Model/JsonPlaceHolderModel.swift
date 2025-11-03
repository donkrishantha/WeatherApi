//
//  JsonPlaceHolderModel.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 02/11/2025.
//

import Foundation

struct JsonPlaceHolderModel: Codable{
    let title: String
    let body: String
    let userId: Int
    let id: Int
}


//{
//    "title": "foodan",
//    "body": "bar",
//    "userId": 2,
//    "id": 101
//}

struct PatchRequestModel: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

//{
//"title": "foo1wwewe"
//}

//{
//    "userId": 1,
//    "id": 1,
//    "title": "foo1wwewe",
//    "body": "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
//}



