//
//  CustomButton.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 21/12/2025.
//

import SwiftUI
//import Foundation

struct CustomButton: View {
    var isLoading: Bool? = false
    var icon: String?
    var title: String
    var action: (() -> Void)
    var bgColor: Color? = .blue
    //var buttonStyle: (any ButtonStyle)? = .borderless
    var foregroundColor: Color? = .gray
    
    init(isLoading: Bool? = nil, icon: String? = nil, title: String,
         action: @escaping () -> Void, bgColor: Color? = nil,
         foregroundColor: Color? = nil) {
        self.isLoading = isLoading
        self.icon = icon
        self.title = title
        self.action = action
        self.bgColor = bgColor
        self.foregroundColor = foregroundColor
    }
    
    var body: some View {
        Button(action: action) { /// call the closure here
            HStack {
                if let icon {
                    Image(systemName: icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                }
                Text(title) /// your text
                    .font(.headline)
                    .lineLimit(1)
                    .background(bgColor)
                    //.foregroundStyle(foregroundColor ?? .white)
                    .minimumScaleFactor(0.5)
                    //.minimumScaleFactor(isLoading ?? false ? 0.9 : 0)
                    //.padding([.leading],5)
                    .offset(x : isLoading ?? false ? -15 : 0)
            }
        }
        //.border(.green)
        .overlay(alignment: .trailing, content: {
                CircularProgressView(isLoading: isLoading)
                    .offset(x : -10)
        })
        //.disabled(isLoading ?? false)
        .opacity(isLoading ?? false ? 0.6 : 1)
        .allowsHitTesting(isLoading ?? false ? false : true)
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .foregroundColor(foregroundColor)
        .buttonBorderShape(.roundedRectangle)
    }
}

#Preview {
    CustomButton(icon: "system.icon", title: "TEST BUTTON TITLE", action: {})
}

extension String {
   func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}
