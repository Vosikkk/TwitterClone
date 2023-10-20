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
    func registerUser(with email: String, password: String) -> AnyPublisher<User, Error>
    func isValidEmail(_ email: String) -> Bool
}

class UserAuth: AuthManager {
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    
    func registerUser(with email: String, password: String) -> AnyPublisher<User, Error> {
      return Auth.auth().createUser(withEmail: email, password: password)
            .map(\.user)
            .eraseToAnyPublisher()
    }
}
