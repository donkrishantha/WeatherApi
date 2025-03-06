//
//  CustomAlert.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 27/12/2024.
//

import Foundation
import SwiftUI

/*@available(iOS 15.0, *)
struct AlertButton: Identifiable {
    var id: String {
        title
    }

    let title: String
    let style: ButtonRole?
    let action: (() -> Void)?
}

struct AlertData {
    let title: String
    let message: String?
    let actions: [AlertButton]
}

struct CustomAlertModifier: ViewModifier {

    @Binding var data: AlertData?

    func body(content: Content) -> some View {
        content
        .alert(
            data?.title ?? "",
            isPresented: Binding<Bool>(
                get: {
                    data != nil
                },
                set: { value in
                    data = value ? data : nil
                }
            ), presenting: data
        ) { data in
            ForEach(data.actions) { action in
                Button(role: action.style, action: action.action ?? { }) {
                    Text(action.title)
                }
            }
        } message: { data in
            if let message = data.message {
                Text(message)
            }
        }
    }
}

extension View {
    func customAlert(data: Binding<AlertData?>) -> some View {
        self.modifier(CustomAlertModifier(data: data))
    }
}
*/
