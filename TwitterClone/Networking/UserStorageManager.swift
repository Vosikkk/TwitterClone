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

protocol StorageManager {
    var storage: StorageReference { get set }
    func uploadProfilePhoto(with randomID: String, image: Data, metaData: StorageMetadata) -> AnyPublisher<StorageMetadata, Error>
}


final class UserStorageManager: StorageManager {
    
    var storage: FirebaseStorage.StorageReference = Storage.storage().reference()
    
    func uploadProfilePhoto(with randomID: String, image: Data, metaData: StorageMetadata) -> AnyPublisher<StorageMetadata, Error> {
       
        return storage
            .child("images/\(randomID).jpg")
            .putData(image, metadata: metaData)
            .eraseToAnyPublisher()
    }
}
