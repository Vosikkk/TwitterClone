//
//  AuthenticationViewModel.swift
//  TwitterClone
//
//  Created by Саша Восколович on 21.10.2023.
//

import Foundation
import Firebase
import Combine

class AuthenticationViewModel: ObservableObject {
    
    @Published var email: String?
    @Published var password: String?
    @Published var isAuthenticationValid: Bool = false
    @Published var user: User?
    
    
    private var subscriptions: Set<AnyCancellable> = []
    
    
    private let userAuth: AuthManager
    
    init(userAuth: AuthManager) {
        self.userAuth = userAuth
    }
    
    
    func validateAuthenticationForm() {
        guard let email = email,
              let password = password else { isAuthenticationValid = false; return }
        isAuthenticationValid = email.isValidEmail() && password.count >= 8
    }
    
    func createUser() {
        guard let email = email,
              let password = password else { return }
        
        userAuth.registerUser(with: email, password: password)
            .sink { _ in
                
            } receiveValue: { [weak self] user in
                self?.user = user
            }
            .store(in: &subscriptions)
    }
    
    func loginUser() {
        guard let email = email,
              let password = password else { return }
        
        userAuth.loginUser(with: email, password: password)
            .sink { _ in
                
            } receiveValue: { [weak self] user in
                self?.user = user
            }
            .store(in: &subscriptions)
    }
    
    func clearData() {
            email = nil
            password = nil
            isAuthenticationValid = false
            user = nil
        }
}

