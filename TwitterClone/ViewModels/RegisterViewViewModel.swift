//
//  RegisterViewViewModel.swift
//  TwitterClone
//
//  Created by Саша Восколович on 20.10.2023.
//

import Foundation
import Firebase
import Combine

final class RegisterViewViewModel: ObservableObject {
  
    @Published var email: String?
    @Published var password: String?
    @Published var isRegestrationValid: Bool = false
    @Published var user: User?
    
    private let userAuth: AuthManager
    private var subscriptions: Set<AnyCancellable> = []
    
    init(userAuth: AuthManager) {
        self.userAuth = userAuth
    }
    
    
    func validationResistrationForm() {
        guard let email = email,
              let password = password else { isRegestrationValid = false;  return }
        
        isRegestrationValid = userAuth.isValidEmail(email) && password.count >= 8
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
    
    deinit {
            print("RegisterViewViewModel деініціалізований")
        }
}
