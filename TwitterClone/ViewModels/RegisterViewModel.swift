//
//  RegisterViewModel.swift
//  TwitterClone
//
//  Created by Саша Восколович on 21.10.2023.
//

import Foundation
import Firebase
import Combine

class RegisterViewModel: ObservableObject {
    
    @Published var email: String?
    @Published var password: String?
    @Published var isRegistrationValid: Bool = false
    @Published var user: User?
    
    
    private var subscriptions: Set<AnyCancellable> = []
    
    
    private let userAuth: AuthManager
    
    init(userAuth: AuthManager) {
        self.userAuth = userAuth
    }
    
    
    func validRigestrationForm() {
        guard let email = email,
              let password = password else { isRegistrationValid = false; return }
        isRegistrationValid = email.isValidEmail() && password.count >= 8
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
}

