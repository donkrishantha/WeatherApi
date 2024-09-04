//
//  LoginView.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 23/08/2024.
//

import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {
        Form {
            TextField("Username", text: $username)
            SecureField("Password", text: $password)
            Button("Log In") {
                // Call ViewModel to handle login
            }
        }
    }
}

#Preview {
    LoginView()
}
