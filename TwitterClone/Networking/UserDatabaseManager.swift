//
//  UserDatabaseManager.swift
//  TwitterClone
//
//  Created by Саша Восколович on 24.10.2023.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreCombineSwift
import Combine

protocol DatabaseManager {
    var db: Firestore { get set }
    var userPath: String { get set }
    func collectionUsers(add user: User) -> AnyPublisher<Bool, Error>
    func collectionUsers(retreive id: String) -> AnyPublisher<TwitterUser, Error>
    func collecttionUsers(updateFields: [String: Any], for id: String) -> AnyPublisher<Bool, Error>
}

final class UserDatabaseManager: DatabaseManager {
   
    var db: Firestore = Firestore.firestore()
    
    var userPath: String = "users"
    
    func collectionUsers(add user: User) -> AnyPublisher<Bool, Error> {
        let twitterUser = TwitterUser(from: user)
        return db.collection(userPath).document(twitterUser.id).setData(from: twitterUser)
            .map { _ in return true }
            .eraseToAnyPublisher()
    }
    
    func collectionUsers(retreive id: String) -> AnyPublisher<TwitterUser, Error> {
        db.collection(userPath).document(id).getDocument()
            .tryMap { try $0.data(as: TwitterUser.self) }
            .eraseToAnyPublisher()
    }
    
    func collecttionUsers(updateFields: [String : Any], for id: String) -> AnyPublisher<Bool, Error> {
       db.collection(userPath).document(id).updateData(updateFields)
            .map { _ in true }
            .eraseToAnyPublisher()
    }
}
