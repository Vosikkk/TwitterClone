//
//  Tweet.swift
//  TwitterClone
//
//  Created by Саша Восколович on 31.10.2023.
//

import Foundation

struct Tweet: Codable, Identifiable {
    var id = UUID().uuidString
    let author: TwitterUser
    let authorID: String 
    let tweetContent: String
    var likesCount: Int
    var likes: [String]
    let isReply: Bool
    let parentReference: String?    
}
