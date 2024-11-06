//
//  User.swift
//  TwitterClone
//
//  Created by Emmanuel Anene on 22/10/2024.
//

import Foundation
import Firebase

struct User {
    var fullName: String
    let email: String
    var useername: String
    var profileImageUrl: URL?
    let uid: String
    var isFollowed = false
    var stats : UserRelationStats?
    var bio: String?
    
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == uid
    }
    
    init(uid: String, dictionary: [String: AnyObject]) {
        self.uid = uid
        
        self.fullName = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.useername = dictionary["username"] as? String ?? ""
        
        if let bio = dictionary["bio"] as? String {
            self.bio = bio
        }
        
        if let profileImageUrlString = dictionary["profileImageUrl"] as? String {
            guard let url = URL(string: profileImageUrlString) else {return}
            self.profileImageUrl = url
        }
    }
}


struct UserRelationStats {
    var followers: Int
    var following: Int
}
