//
//  Date.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 09/08/2024.
//

import Foundation

extension Date {
    
    func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func dateAndTimeToString(format: String = "yyyy-MM-dd HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func timeIn24HourFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
}

