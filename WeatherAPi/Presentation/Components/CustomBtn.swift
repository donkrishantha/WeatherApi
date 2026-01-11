//
//  CustomBtn.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 30/12/2025.
//

import Foundation
import SwiftUI

struct LoadingButtonStyle: ButtonStyle {
    @Environment(\.appButtonTags) private var appButtonTag : MainModelButtonTags
    @Binding var tag: MainModelButtonTags
    @Binding var isLoading: Bool
    var bgColor: Color? = Color.blue

    func makeBody(configuration: Configuration) -> some View {
        let isLoading = (tag == appButtonTag) && isLoading
        let disable = isLoading ? false : true
        let opacity = isLoading ? 0.5 : 1
        
        configuration.label
            .commonButtonStyle()
            .background(bgColor.cornerRadius(8))
            .opacity(opacity)
            .allowsHitTesting(disable)
            //.animation(.default, value: isLoading)
            .frame(height: 55)
            .overlay {
                progressViewOverlay(isLoading: isLoading)
            }
    }
    
    @ViewBuilder
    func progressViewOverlay(isLoading: Bool) -> some View {
        withAnimation {
            CircularProgressView(isLoading: isLoading)
        }
    }
}

struct GeneralButtonStyle: ButtonStyle {
    @Environment(\.appButtonTags) var appButtonTag : MainModelButtonTags
    @Binding var tag: MainModelButtonTags
    var bgColor: Color? = Color.blue

    func makeBody(configuration: Configuration) -> some View {
        let isTap = (tag == appButtonTag)
        let disable = configuration.isPressed ? false : true
        let opacity = configuration.isPressed ? 0.5 : 1
        
        configuration.label
            .commonButtonStyle()
            .background(bgColor.cornerRadius(8))
            .opacity(opacity)
            .allowsHitTesting(disable)
            .animation(.default, value: isTap)
            .frame(height: 55)
    }
}

struct PrimaryButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .foregroundColor(.white)
    }
}

extension View {
    func commonButtonStyle() -> some View {
        self.modifier(PrimaryButtonModifier())
    }
}
