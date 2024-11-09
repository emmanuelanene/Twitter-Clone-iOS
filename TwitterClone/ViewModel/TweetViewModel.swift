//
//  TweetViewModel.swift
//  TwitterClone
//
//  Created by Emmanuel Anene on 08/11/2024.
//

import UIKit

struct TweetViewModel {
    let tweet: Tweet
    let user: User
    
    var profileImageUrl: URL? {
        return user.profileImageUrl
    }
    
    var timestamp: String {
        let formatter = DateComponentsFormatter()
        
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.unitsStyle = .abbreviated
        formatter.maximumUnitCount = 1
        
        let now = Date()
        return formatter.string(from: tweet.timeStamp, to: now) ?? "2m"
    }
    
    
    
    var usernameText: String {
        return "@\(user.useername)"
    }
    
    
    var headerTimeStamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a · MM/dd/yyyy"
        return formatter.string(from: tweet.timeStamp)
    }
    
    
    
    // ATTRIBUTED STRING
    fileprivate func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(
            string: "\(value)",
            attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)
            ]
        )
        
        attributedTitle.append(NSAttributedString(
            string: text,
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                NSAttributedString.Key.foregroundColor: UIColor.lightGray
            ]
        ))
        
        return attributedTitle
    }
    // END OF ATTRIBUTED STRING
    
    
    
    
    
    
    
    
    
    var retweetsAttributedString: NSAttributedString? {
        return attributedText(withValue: tweet.retweetCount, text: "Retweets")
    }
    
    var likesAttributedString: NSAttributedString? {
        return attributedText(withValue: tweet.likes, text: "Likes")
    }
    
    var userInfoText: NSAttributedString {
        let title = NSMutableAttributedString(
            string: user.fullName,
            attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)
            ]
        )
        
        
        title.append(NSAttributedString(
            string: "@\(user.useername)",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.lightGray
            ]
        ))
        
        
        title.append(NSAttributedString(
            string: " · \(timestamp)",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.lightGray
            ]
        ))
        
        return title
    }
    
    
    var likeButtonTintColor: UIColor {
        return tweet.didLike ? UIColor.red :  UIColor.lightGray
    }
    
    var likeButtonImage: UIImage {
        let imageName = tweet.didLike ? "like_filled" : "like"
        return UIImage(named: imageName)!
    }
    
    var shouldHideReplyLabel: Bool {
        return !tweet.isReply
    }
    
    var replyText: String? {
        guard let replyingToUsername = tweet.replyingTo else {return nil}
        return "Replying to @\(replyingToUsername)"
    }
    
    
    
    init(tweet: Tweet) {
        self.user = tweet.user
        self.tweet = tweet
    }
    
}
