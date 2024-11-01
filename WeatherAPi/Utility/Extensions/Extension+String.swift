//
//  String.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 09/08/2024.
//

import UIKit

extension String {
    
    func roundTripDate(style: DateFormatter.Style) -> String? {
        //set things up
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current

        formatter.dateFormat = "yyyy-mm-dd HH:mm"
        guard let date = formatter.date(from: self) else {
            return nil
        }

        formatter.dateStyle = style // this is the date format going out
        return formatter.string(from: date)
    }
    
    func timeIn24HourFormat() -> String? {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "en_US_POSIX")
        
        formatter.dateStyle = .none
        formatter.dateFormat = "hh:mm a"
        guard let date = formatter.date(from: self) else {
            return nil
        }
        return formatter.string(from: date)
    }
    
    func convertBase64ToImage(imageString: String) -> UIImage {
        let imageData = Data(base64Encoded: imageString,
                             options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
        return UIImage(data: imageData)!
    }
}
