//
//  Tweet.swift
//  TwitterClone
//
//  Created by Emmanuel Anene on 22/10/2024.
//

import Foundation

struct Tweet {
    let caption: String
    let tweetID: String
    var likes: Int
    var timeStamp: Date!
    let retweetCount: Int
    var user: User
    var didLike = false
    var replyingTo: String?
    
    var isReply: Bool {
        return replyingTo != nil
    }
    
    
    
    init(user: User, tweetID: String, dictionary: [String: AnyObject]) {
        self.user = user
        self.tweetID = tweetID
        
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.retweetCount = dictionary["retweetCount"] as? Int ?? 0
        
        if let timeStamp = dictionary["timestamp"] as? Double {
            self.timeStamp = Date(timeIntervalSince1970: timeStamp)
        }
        
        if let replyingTo = dictionary["replyingTo"] as? String {
            self.replyingTo = replyingTo
        }
        

    }
}
