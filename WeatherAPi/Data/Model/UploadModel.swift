//
//  UploadModel.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 10/09/2024.
//

import Foundation

struct UploadModel: Codable {
    let result: Result
    let success: Bool
    let error: [String]
    let messages: [Messages]
    
    struct Result: Codable {
        let id: Int
        let status: String
    }
    
    struct Messages: Codable {
        let code: Int
        let message: String
        //let type: NSNull
    }
}

struct ImageUploadErrorModel: Codable {
    let success: Bool
    let error: [Errors]
    let messages: [String]
    //let result: NSNull
    
    struct Errors: Codable {
        let code: Int
        let message: String
        let error_chain: [ErrorChain]
        let messages: [String]
        
        struct ErrorChain: Codable {
            let code: Int
            let message: String
        }
    }
}

struct ImageResponse: Codable {
    let fileId: String
    let name: String
    let filePath: String
    let url: String
    let fileType: String
    let thumbnailUrl: String
}

/*
 
 {
   "fileId": "6673f88237b244ef54d60180",
   "name": "test-image.jpg",
   "size": 117079,
   "versionInfo": {
     "id": "6673f88237b244ef54d60180",
     "name": "Version 1"
   },
   "filePath": "/test-image.jpg",
   "url": "https://ik.imagekit.io/demo/test-image.jpg",
   "fileType": "image",
   "height": 500,
   "width": 1000,
   "orientation": 1,
   "thumbnailUrl": "https://ik.imagekit.io/demo/tr:n-ik_ml_thumbnail/test-image.jpg"
 }

 
 {
     "result": {
         "id": "07540d17a9e424a3c48c6c387f433464",
         "status": "active"
     },
     "success": true,
     "errors": [],
     "messages": [
         {
             "code": 10000,
             "message": "This API Token is valid and active",
             "type": null
         }
     ]
 }
 
 {
     "success": false,
     "errors": [
         {
             "code": 6003,
             "message": "Invalid request headers",
             "error_chain": [
                 {
                     "code": 6111,
                     "message": "Invalid format for Authorization header"
                 }
             ]
         }
     ],
     "messages": [],
     "result": null
 }
 */
