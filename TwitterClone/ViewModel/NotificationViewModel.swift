//
//  NotificationViewModel.swift
//  TwitterClone
//
//  Created by Emmanuel Anene on 08/11/2024.
//

import UIKit

struct NotificationViewModel {
    private let notification: Notification
    private let type: NotificationType
    private let user: User
    
    var timestampString: String? {
        let formatter = DateComponentsFormatter()
        
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        
        let now = Date()
        return formatter.string(from: notification.timestamp, to: now) ?? "2m"
    }
    
    
    var notificationMessage: String {
        switch type {
            case .follow: return "@\(user.useername) followed you"
            case .like: return "@\(user.useername) likes your post"
            case .reply: return "@\(user.useername) replied to your tweet"
            case .mention: return "@\(user.useername) mentioned you in a tweet"
        }
    }
    
    
    var notificationText: NSAttributedString? {
        guard let timestamp = timestampString else { return nil }
        
        let attributedString = NSMutableAttributedString(
            string: user.useername,
            attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)
            ]
        )
        
        attributedString.append(NSAttributedString(
            string: notificationMessage,
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)
            ]
        ))
        
        attributedString.append(NSAttributedString(
            string: "\(timestamp)",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
                NSAttributedString.Key.foregroundColor: UIColor.lightGray
            ]
        ))
        
        return attributedString
    }
    
    
    var profileImageUrl: URL? {
        return user.profileImageUrl
    }
    
    var shouldHideFollowButton: Bool {
        return type != .follow
    }
    
    var followButtonText: String {
        return user.isFollowed ? "Following" : "Follow"
    }
    
    
    
    
    init(notification: Notification) {
        self.notification = notification
        self.type = notification.type
        self.user = notification.user
    }
}
