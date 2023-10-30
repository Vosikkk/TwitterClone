//
//  ProfileDataFormViewModel.swift
//  TwitterClone
//
//  Created by Саша Восколович on 24.10.2023.
//

import Foundation
import Combine
import FirebaseStorage


final class ProfileDataFormViewModel: ObservableObject {
    
    @Published var displayName: String?
    @Published var username: String?
    @Published var bio: String?
    @Published var avatarPath: String?
    @Published var imageData: Data?
    @Published var isFormValid: Bool = false
    @Published var error: String = ""
    
    
    
    private let userStorageManager: StorageManager
    
    init(userStorageManager: StorageManager) {
        self.userStorageManager = userStorageManager
    }
    
    
    func validateUserProfileForm() {
        guard let displayName = displayName,
              displayName.count > 2,
              let username = username,
              username.count > 2,
              let bio = bio,
              bio.count > 2,
              imageData != nil else { isFormValid = false; return }
        
        isFormValid = true
    }
    
    func uploadAvatar() {
        userStorageManager.uploadProfilePhoto(with: <#T##String#>, image: <#T##Data#>, metaData: <#T##StorageMetadata#>)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { metaData in
                
            }

    }
}
