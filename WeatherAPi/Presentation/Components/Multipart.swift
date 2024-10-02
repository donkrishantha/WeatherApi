//
//  Multipart.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 17/09/2024.
//

import Foundation

class Multipart {
    
    let headers = [
        "Content-Type": "multipart/form-data; boundary=---011000010111000001101001",
        "Accept": "application/json",
        "Authorization": "Basic cHJpdmF0ZV9JUy9TTUlZNi9PeWUySzdzNHFiVTFzRnRoVjA9Og=="
    ]
    
    let parameters = [
        [
            "name": "file",
         "value": ""
        ],
        [
            "name": "fileName",
            "value": ""
        ],
        [
            "name": "publicKey",
            "value": ""
        ],
        [
            "name": "signature",
            "value": ""
        ],
        [
            "name": "expire",
            "value": ""
        ],
        [
            "name": "token",
            "value": ""
        ],
        [
            "name": "useUniqueFileName",
            "value": ""
        ],
        [
            "name": "tags",
            "value": ""
        ],
        [
            "name": "folder",
            "value": ""
        ],
        [
            "name": "isPrivateFile",
            "value": ""
        ],
        [
            "name": "isPublished",
            "value": ""
        ],
        [
            "name": "customCoordinates",
            "value": ""
        ],
        [
            "name": "responseFields",
            "value": ""
        ],
        [
            "name": "extensions",
            "value": ""
        ],
        [
            "name": "webhookUrl",
            "value": ""
        ],
        [
            "name": "overwriteFile",
            "value": ""
        ],
        [
            "name": "overwriteAITags",
            "value": ""
        ],
        [
            "name": "overwriteTags",
            "value": ""
        ],
        [
            "name": "overwriteCustomMetadata",
            "value": ""
        ],
        [
            "name": "customMetadata",
            "value": ""
        ],
        [
            "name": "transformation",
            "value": ""
        ],
        [
            "name": "checks",
            "value": ""
        ]
    ]
    
    let boundary = "---011000010111000001101001"
    
    var body = ""
    var error: NSError? = nil
    
    func appendData() {
        for param in parameters {
            let paramName = param["name"]!
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(paramName)\""
            if let filename = param["fileName"] {
                let contentType = param["content-type"]!
                let fileContent = (try? String(contentsOfFile: filename, encoding: String.Encoding.utf8)) ?? ""
                if (error != nil) {
                    print(error as Any)
                }
                body += "; filename=\"\(filename)\"\r\n"
                body += "Content-Type: \(contentType)\r\n\r\n"
                body += fileContent
            } else if let paramValue = param["value"] {
                body += "\r\n\r\n\(paramValue)"
            }
        }
    }
    
    func sendRequest() {
        let request = NSMutableURLRequest(url: NSURL(string: "https://upload.imagekit.io/api/v1/files/upload")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        let bodyData: Data? = body.data(using: .utf8) // non-nil
        request.httpBody = bodyData
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse ?? 0)
            }
        })
        
        dataTask.resume()
    }
}
