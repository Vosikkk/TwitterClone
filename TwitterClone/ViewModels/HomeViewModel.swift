//
//  HomeViewModel.swift
//  TwitterClone
//
//  Created by Саша Восколович on 24.10.2023.
//

import Foundation
import Combine
import FirebaseAuth

final class HomeViewModel: ObservableObject {
    
    @Published var user: TwitterUser?
    @Published var error: String?
    @Published var tweets: [Tweet] = []
    
    private var subscriptions: Set<AnyCancellable> = []
    
    private let userDatabaseManager: DatabaseManager
    
    
    init(userDatabaseManager: DatabaseManager) {
        self.userDatabaseManager = userDatabaseManager
    }
    
    
    func retreiveUser() {
        
        guard let id = Auth.auth().currentUser?.uid else { return }
        
        userDatabaseManager.collectionUsers(retreive: id)
            .handleEvents(receiveOutput: { [weak self] user in
                self?.user = user
                self?.fetchTweets()
            })
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
                
            } receiveValue: { [weak self] user in
                self?.user = user
            }
            .store(in: &subscriptions)
    }
    
    func fetchTweets() {
        guard let userID = user?.id else { return }
        
        userDatabaseManager.collectionTweets(retreiveTweets: userID)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] retrievedTweets in
                self?.tweets = retrievedTweets
            }
            .store(in: &subscriptions)
    }
    
    deinit {
            print("HomeViewModel деініціалізований")
        }
}
