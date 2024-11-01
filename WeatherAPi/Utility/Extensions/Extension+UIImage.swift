//
//  Extension+UIImage.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 08/10/2024.
//

import UIKit

func convertImageToBase64(image: UIImage) -> String {
    let imageData = image.pngData()!
    return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
}
