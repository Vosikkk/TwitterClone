//
//  UserAuth.swift
//  TwitterClone
//
//  Created by Саша Восколович on 21.10.2023.
//

import Foundation
import Firebase
import FirebaseAuthCombineSwift
import Combine

protocol AuthManager {
    func register(with email: String, password: String) -> AnyPublisher<User, Error>
    func login(with email: String, password: String) -> AnyPublisher<User, Error>
}

final class UserAuth: AuthManager {
    
    func login(with email: String, password: String) -> AnyPublisher<User, Error> {
        return Auth.auth().signIn(withEmail: email, password: password)
            .map(\.user)
            .eraseToAnyPublisher()
    }
    
    func register(with email: String, password: String) -> AnyPublisher<User, Error> {
      return Auth.auth().createUser(withEmail: email, password: password)
            .map(\.user)
            .eraseToAnyPublisher()
    }
}

