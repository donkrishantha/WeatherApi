//
//  JsonLoader.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 09/08/2024.
//

import Foundation

class FileLoader {
    
    static func readLocalFile(_ filename: String) -> Data? {
        guard let file = Bundle.main.path(forResource: filename, ofType: "json")
                
        else {
            fatalError("Unable to locate file \"\(filename)\" in main bundle.")
        }
        
        do {
            return try String(contentsOfFile: file).data(using: .utf8)
        } catch {
            fatalError("Unable to load \"\(filename)\" from main bundle:\n\(error)")
        }
    }
    
    
    static func loadJson(_ data: Data) -> WeatherRowData {
        do {
            return try JSONDecoder().decode(WeatherRowData.self, from: data)
        } catch {
            fatalError("Unable to decode  \"\(data)\" as \(WeatherRowData.self):\n\(error)")
        }
    }
}
