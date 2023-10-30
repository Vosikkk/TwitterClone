//
//  UserStorageManager  .swift
//  TwitterClone
//
//  Created by Саша Восколович on 29.10.2023.
//

import Foundation
import Combine
import FirebaseStorageCombineSwift
import FirebaseStorage


enum FirestoregeError: Error {
    case invalidImageID
}


protocol StorageManager {
    var storage: Storage { get set }
    func uploadProfilePhoto(with randomID: String, image: Data, metaData: StorageMetadata) -> AnyPublisher<StorageMetadata, Error>
    func getDownloadURL(for id: String?) -> AnyPublisher<URL, Error>
}


final class UserStorageManager: StorageManager {
   
    var storage: FirebaseStorage.Storage = Storage.storage()
    
    func uploadProfilePhoto(with randomID: String, image: Data, metaData: StorageMetadata) -> AnyPublisher<StorageMetadata, Error> {
       
        return storage
            .reference()
            .child("images/\(randomID).jpg")
            .putData(image, metadata: metaData)
            .print()
            .eraseToAnyPublisher()
    }
    
    func getDownloadURL(for id: String?) -> AnyPublisher<URL, Error> {
        guard let id = id else {
            return Fail(error: FirestoregeError.invalidImageID).eraseToAnyPublisher()
        }
        return storage
            .reference(withPath: id)
            .downloadURL()
            .print()
            .eraseToAnyPublisher()
    }
}
