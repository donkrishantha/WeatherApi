//
//  Mockable.swift
//  WeatherAPiTests
//
//  Created by Gayan Dias on 16/08/2024.
//

import XCTest
import Foundation
@testable import WeatherAPi

enum FileExtensionType: String {
    case json = ".json"
}

protocol Mockable: AnyObject {
    var bundle: Bundle { get }
    func loadJSON<T: Decodable>(filename: String, extensionType: FileExtensionType, type: T.Type) -> T
}

extension Mockable {
    var bundle: Bundle {
        return Bundle(for: type(of: self))
    }

    func loadJSON<T: Decodable>(filename: String,
                                extensionType: FileExtensionType,
                                type: T.Type) -> T {
        
        guard let path = bundle.url(forResource: filename, withExtension: extensionType.rawValue) else {
            XCTAssert(false, "Can't get data from sample.json")
            fatalError("Failed to load JSON file.")
        }

        do {
            let data = try Data(contentsOf: path)
            let decodedObject = try JSONDecoder().decode(type, from: data)

            return decodedObject
        } catch {
            print("❌ \(error)")
            fatalError("Failed to decode loaded JSON file.")
        }
    }
}
