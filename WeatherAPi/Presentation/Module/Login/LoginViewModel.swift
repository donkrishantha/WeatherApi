//
//  LoginViewModel.swift
//  WeatherAPi
//
//  Created by Gayan Dias on 17/10/2024.
//

import Foundation
import Combine

final class LoginViewModel: ObservableObject {
    
    // Input values from view
    @Published var userName = ""
    @Published var userEmail = ""
    @Published var userPassword = ""
    @Published var userRepeatedPassword = ""
    
    // Output subscribers
    @Published var formIsValid = false
    @Published var errorMessage = ""
    
    private var publishers = Set<AnyCancellable>()
    
    init() {
        isSignupFormValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.formIsValid, on: self)
            .store(in: &publishers)
    }
}

// MARK: - Setup validations
private extension LoginViewModel {
    
    var isUserNameValidPublisher: AnyPublisher<Bool, Never> {
        $userName
            .map { [weak self] name in
                if !(name.count >= 3) { (self?.errorMessage = "* Enter valid user name")}
                return name.count >= 3
            }
            .eraseToAnyPublisher()
    }
    
    
    var isUserEmailValidPublisher: AnyPublisher<Bool, Never> {
        $userEmail
            .map { [weak self] email in
                let emailPredicate = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
                if !emailPredicate.evaluate(with: email) {(self?.errorMessage = "* Enter valid email")}
                return emailPredicate.evaluate(with: email)
            }
            .eraseToAnyPublisher()
    }
    
    var isPasswordValidPublisher: AnyPublisher<Bool, Never> {
        $userPassword
            .map { [weak self] password in
                if !(password.count >= 8) {(self?.errorMessage = "* Enter valid password")}
                return password.count >= 8
            }
            .eraseToAnyPublisher()
    }
    
    var passwordMatchesPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($userPassword, $userRepeatedPassword)
            .map { [weak self] password, repeated in
                if (password != repeated) { (self?.errorMessage = "* Password not match") }
                return password == repeated
            }
            .eraseToAnyPublisher()
    }
    
    var isSignupFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest4(
            isUserNameValidPublisher,
            isUserEmailValidPublisher,
            isPasswordValidPublisher,
            passwordMatchesPublisher)
        .map { [weak self] isNameValid, isEmailValid, isPasswordValid, passwordMatches in
            if (isNameValid && isEmailValid && isPasswordValid && passwordMatches) {self?.errorMessage = ""}
            return isNameValid && isEmailValid && isPasswordValid && passwordMatches
        }
        .eraseToAnyPublisher()
    }
}
