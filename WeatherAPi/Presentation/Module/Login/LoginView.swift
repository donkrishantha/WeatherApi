//
//  LoginView.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 23/08/2024.
//

import SwiftUI

struct LoginView: View {
    
    @ObservedObject private var viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView{
            VStack {
                Form {
                    Section(header: Text("Login field"), footer: Text(" \(viewModel.errorMessage)").foregroundColor(.red) ) {
                        TextField("Name", text: $viewModel.userName)
                        TextField("Email", text: $viewModel.userEmail)
                            .keyboardType(.emailAddress)
                        SecureField("Password", text: $viewModel.userPassword)
                        SecureField("Repete the Password", text: $viewModel.userRepeatedPassword)
                    }
                    
                    Button("Sign Up") {
                        print("Button tapped")
                        viewModel.getWeatherInfor()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .opacity(buttonOpacity)
                    .cornerRadius(8)
                    .disabled(!viewModel.formIsValid)
                }
                BasketballGameView()
            }
        }.navigationTitle("Login!")
        
        var buttonOpacity: Double {
            return viewModel.formIsValid ? 1 : 0.5
        }
    }
}

struct LoginView_Preview: PreviewProvider {
    static var previews: some View {
        //let viewModel: LoginViewModel = LoginViewModel()
        //LoginView(viewModel: viewModel)
        BasketballGameView()
        ScoreView(teamName: "Team A")
    }
}

struct BasketballGameView: View {
    //@State private var quarter = 1
    @ObservedObject private var score = Score()
    
    var body: some View {
        VStack {
            bodySection
        }
    }
    
    @ViewBuilder private var bodySection: some View {
        if score.quarter <= 4 {
            Button(score.quarter < 4 ? "Next Quarter" : "End Game") {
                score.incrementQuoter()
            }
            HStack {
                ScoreView(teamName: "Team A")
                ScoreView(teamName: "Team B")
            }
            Text("Quarter: \(score.quarter)")
        } else {
            Text("Game Ended")
        }
    }
    
//    private var scoreView: some View {
//        HStack {
//            ScoreView(teamName: "Team A")
//                //.pinkLabel()
//            ScoreView(teamName: "Team B")
//                //.pinkLabel()
//        }
//    }
}

struct ScoreView: View {
    @ObservedObject private var score = Score()
    fileprivate let teamName: String
    
    var body: some View {
        Button("\(teamName): \(score.points)") {
            score.points += 1
        }
    }
}

final class Score: ObservableObject {
    @Published var points = 0
    @Published var quarter = 1
    
    //init() {}
    
    func incrementQuoter() {
        quarter += 1
    }
}

struct PinkLabel: ViewModifier {
    func body(content: Content) -> some View {
        content.foregroundColor(.orange)
    }
}

extension View {
    func pinkLabel() -> some View {
        modifier(PinkLabel())
    }
}

//---------------------------------------------
/*struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundStyle(.white)
            .padding()
            .background(.blue)
            .clipShape(.rect(cornerRadius: 10))
    }
}

Text("Hello World")
    .modifier(Title())

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}*/
