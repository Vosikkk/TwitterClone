//
//  TweetComposeViewModel.swift
//  TwitterClone
//
//  Created by Саша Восколович on 31.10.2023.
//

import Foundation
import Combine
import FirebaseAuth


final class TweetComposeViewModel: ObservableObject {
    
    private var subscriptions: Set<AnyCancellable> = []
    
    @Published var isValideToTweet: Bool = false
    @Published var error: String = ""
    @Published var shouldDismissScreen: Bool = false
    
    var tweetContent: String = ""
    private var user: TwitterUser?
    private let userDatabaseManager: DatabaseManager
    
    
    init(userDatabaseManager: DatabaseManager) {
        self.userDatabaseManager = userDatabaseManager
    }
    
    
    func getUserData() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        userDatabaseManager.collectionUsers(retreive: userID)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [unowned self] user in
                self.user = user
                
            }.store(in: &subscriptions)
    }
    
    
    func validateTweet() {
        isValideToTweet = !tweetContent.isEmpty
    }
    
    func dispatchTweet() {
        guard let user = user else { return }
        let tweet = Tweet(author: user, authorID: user.id, tweetContent: tweetContent, likesCount: 0, likes: [], isReply: false, parentReference: nil)
        
        userDatabaseManager.collectionTweets(dispatch: tweet)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] state in
                self?.shouldDismissScreen = state
            }
            .store(in: &subscriptions)
        
    }
}
