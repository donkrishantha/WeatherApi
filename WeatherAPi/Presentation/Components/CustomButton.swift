//
//  CustomButton.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 21/12/2025.
//

import SwiftUI

struct CustomButton: View {
    var isLoading: Bool? = false
    var icon: String?
    var title: String
    var bgColor: Color? = .blue
    var foregroundColor: Color? = .gray
    var action: (() -> Void)
    
    init(isLoading: Bool? = nil, icon: String? = nil, title: String,
         bgColor: Color? = nil, foregroundColor: Color? = nil,
         action: @escaping () -> Void) {
        self.isLoading = isLoading
        self.icon = icon
        self.title = title
        self.action = action
        self.bgColor = bgColor
        self.foregroundColor = foregroundColor
    }
    
    var body: some View {
            Button(action: action) { /// call the closure here
                Label(String(describing: "Button"), systemImage: "plus.circle")
                    .font(.headline)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .offset(x : isLoading ?? false ? -15 : 0)
            }
            .overlay(content: {
                CircularProgressView(isLoading: isLoading ?? false)
                        .offset(x : -10)
            })
            .tint(bgColor)
            .opacity(isLoading ?? false ? 0.6 : 1)
            .allowsHitTesting(isLoading ?? false ? false : true)
            .buttonStyle(.borderedProminent)
            .controlSize(.regular)
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

extension String {
    var isBlank: Bool {
        return allSatisfy({ $0.isWhitespace })
    }
}

extension Optional where Wrapped == String {
    var isBlank: Bool {
        return self?.isBlank ?? true
    }
    
    var isEmptyOrNil: Bool {
        return self?.isEmpty ?? true
    }
}
