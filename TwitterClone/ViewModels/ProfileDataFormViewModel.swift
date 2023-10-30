//
//  ProfileDataFormViewModel.swift
//  TwitterClone
//
//  Created by Саша Восколович on 24.10.2023.
//

import Foundation
import Combine
import FirebaseStorage
import Firebase

final class ProfileDataFormViewModel: ObservableObject {
    
    @Published var displayName: String?
    @Published var username: String?
    @Published var bio: String?
    @Published var avatarPath: String?
    @Published var imageData: Data?
    @Published var isFormValid: Bool = false
    @Published var error: String = ""
    @Published var isOnboardingFinished: Bool = false
    
    private var subscriptions: Set<AnyCancellable> = []
    
    
    private let userStorageManager: StorageManager
    private let databaseManager: DatabaseManager
    
    
    init(userStorageManager: StorageManager, databaseManager: DatabaseManager) {
        self.userStorageManager = userStorageManager
        self.databaseManager = databaseManager
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
        
        let randomID = UUID().uuidString
        guard let imageData = imageData else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        userStorageManager.uploadProfilePhoto(with: randomID, image: imageData, metaData: metaData)
            .flatMap({ [unowned self] metaData in
                self.userStorageManager.getDownloadURL(for: metaData.path)
            })
            .sink { [weak self] completion in
                
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.error = error.localizedDescription
                case .finished:
                    self?.updateUserData()
                }
            } receiveValue: { [weak self] url in
                
                self?.avatarPath = url.absoluteString
            }
            .store(in: &subscriptions)
    }
    
    private func updateUserData() {
        guard let displayName,
              let username,
              let bio,
              let avatarPath,
              let id = Auth.auth().currentUser?.uid else { return }
        
        let updatedFields: [String: Any] = [
            "displayName": displayName,
            "username": username,
            "bio": bio,
            "avatarPath": avatarPath,
            "isUserOnboarded": true
        ]
        databaseManager.collecttionUsers(updateFields: updatedFields, for: id)
            .sink { [weak self] completion in
                
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] updated in
                
                self?.isOnboardingFinished = updated
           
            }.store(in: &subscriptions)
    }
    
    func clearData() {
        subscriptions.forEach { $0.cancel() }
        username = nil
        bio = nil
        avatarPath = nil
        imageData = nil
        isFormValid = false
        isOnboardingFinished = false
    }
}
