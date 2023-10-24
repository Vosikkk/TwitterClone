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
    @Published var error: String?
    
    
    private var subscriptions: Set<AnyCancellable> = []
    
    
    private let userAuth: AuthManager
    private let storageUserManager: DatabaseManager
    
    
    init(userAuth: AuthManager, storageUserManager: DatabaseManager) {
        self.userAuth = userAuth
        self.storageUserManager = storageUserManager
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
            .handleEvents(receiveOutput: { [weak self] user in
            self?.user = user
            })
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.createRecord(for: user)
            }
            .store(in: &subscriptions)
    }
    
    private func createRecord(for user: User) {
        storageUserManager.collectionUsers(add: user)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { state in
                print("Adding user record to database: \(state)")
            }
            .store(in: &subscriptions)

    }
    
    func loginUser() {
        guard let email = email,
              let password = password else { return }
        
        userAuth.loginUser(with: email, password: password)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
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
            error = nil
        }
}

