//
//  Mockable.swift
//  WeatherAPiTests
//
//  Created by Gayan Dias on 16/08/2024.
//

import Foundation

//enum FileExtensionType: String {
//    case json = ".json"
//}
//
//protocol Mockable: AnyObject {
//    var bundle: Bundle { get }
//    func loadJSON<T: Decodable>(filename: String, type: T.Type) -> T
//}
//
//extension Mockable {
//    var bundle: Bundle {
//        return Bundle(for: type(of: self))
//    }
//
//    func loadJSON<T: Decodable>(filename: String,
//                                extensionType: FileExtensionType,
//                                type: T.Type) -> T {
//        
//        guard let path = bundle.url(forResource: filename, withExtension: "json") else {
//            fatalError("Failed to load JSON")
//            //XCTAssert(false, "Can't get data from sample.json")
//        }
//
//        do {
//            let data = try Data(contentsOf: path)
//            let decodedObject = try JSONDecoder().decode(type, from: data)
//
//            return decodedObject
//        } catch {
//            fatalError("Failed to decode loaded JSON")
//        }
//    }
//}
