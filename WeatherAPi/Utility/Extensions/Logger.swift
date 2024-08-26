//
//  Logger.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 14/08/2024.
//

import OSLog

extension Logger {
    /// Using your bundle identifier is a great way to ensure a unique identifier.
    static let subsystem = Bundle.main.bundleIdentifier!
    
    /// Logs the view cycles like a view that appeared.
    static let viewCycle = Logger(subsystem: subsystem, category: "ViewCycle")
    
    static let fileLocation = Logger(subsystem: subsystem, category: "FileLocation")
    
    static let dataStore = Logger(subsystem: subsystem, category: "DataStore")
    
    static let fileManager = Logger(subsystem: subsystem, category: "FileManager")
    
    static let apiClient = Logger(subsystem: subsystem, category: "APIClient")
}
