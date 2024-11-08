//
//  UploadTweetViewModel.swift
//  TwitterClone
//
//  Created by Emmanuel Anene on 08/11/2024.
//

import UIKit

enum UploadTweetConfiguration {
    case tweet
    case reply(Tweet)
}


struct UploadTweetViewModel {
    let actionButtonTitle: String
    let placeholderText: String
    var shouldShowReplyLabel: Bool
    var replyText: String?
    
    
    init(config: UploadTweetConfiguration) {
        switch config {
        case .tweet:
            actionButtonTitle = "Tweet"
            placeholderText = "What's happening"
            shouldShowReplyLabel = false
            
        case .reply(let tweet):
            actionButtonTitle = "Reply"
            placeholderText = "Tweet your reply"
            shouldShowReplyLabel = true
            replyText = "Replying to \(tweet.user.useername)"
        }
    }
}
