//
//  ProfileHeaderViewModel.swift
//  TwitterClone
//
//  Created by Emmanuel Anene on 08/11/2024.
//

import UIKit

enum ProfileFilterOptions: Int, CaseIterable {
    case tweets
    case replies
    case likes
    
    var description: String {
        switch self {
            case .tweets: return "Tweets"
            case .replies: return "Replies"
            case .likes: return "Likes"
        }
    }
}


struct ProfileHeaderViewModel {
    private let user: User
    
    let usernameText: String
    
     fileprivate func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attriibutedTitle = NSMutableAttributedString(
            string: "\(value)",
            attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)
            ]
        )
        
        attriibutedTitle.append(NSAttributedString(
            string: text,
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                NSAttributedString.Key.backgroundColor: UIColor.lightGray
            ]
        ))
        
        return attriibutedTitle
    }
    
    var followersString: NSAttributedString? {
        return attributedText(withValue: user.stats?.followers ?? 0, text: "followers")
    }
    
    var followingString: NSAttributedString? {
        return attributedText(withValue: user.stats?.following ?? 0, text: "following")
    }
    
    var actionButtonTitle: String {
        if user.isCurrentUser {
            return "Edit Profile"
        }
        
        if !user.isFollowed {
            return "Follow"
        }
        
        if user.isFollowed {
            return "Unfollow"
        }
        
        return "Loading"
    }
    
    init(user: User) {
        self.user = user
        self.usernameText = "@" + user.useername
    }
}
