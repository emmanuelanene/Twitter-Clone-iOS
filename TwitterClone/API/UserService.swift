//
//  UserService.swift
//  TwitterClone
//
//  Created by Emmanuel Anene on 08/11/2024.
//

import UIKit
import Firebase

typealias DatabaseCompletion = (Error?, DatabaseReference?) -> Void

struct UserService {
    static let shared = UserService()
    
    func fetchUser(uid: String, completion: @escaping(User) -> Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value) {
            snapshot in
            
            guard let dictionary = snapshot.value as? [String: AnyObject] else {return}
            
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
    
    // The reason we didn't add the "uid" parameter is cause we want to return all the USer dats. ALL OF THEM. So it wont make any sense to ask the person to input an array odf UIDs
    func fetchUsers(completion: @escaping([User]) -> Void) {
        var users = [User]()
        
        REF_USERS.observe(.childAdded) {
            snapshot in
            
            let uid = snapshot.key
            guard let dictionary = snapshot.value as? [String: AnyObject] else {return}
            
            let user = User(uid: uid, dictionary: dictionary)
            
            users.append(user)
            completion(users)
        }
    }
    
    
    func followUser(uid: String, completion: @escaping(DatabaseCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        REF_USER_FOLLOWING.child(currentUid).updateChildValues([uid: 1]) {
            error, ref in
            
            if let error = error {
                completion(error, nil)
                return
            }
            
            REF_USER_FOLLOWERS.child(uid).updateChildValues([currentUid: 1])
            completion(nil, ref)
        }
    }
    
    
    func unfollowUser(uid: String, completion: @escaping(DatabaseCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        REF_USER_FOLLOWING.child(currentUid).child(uid).removeValue {
            err, ref in
            
            REF_USER_FOLLOWERS.child(uid).child(currentUid).removeValue(completionBlock: completion)
        }
    }
    
    
    
    func checkIfUserIsUnfollowed(uid: String, completion: @escaping(Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        REF_USER_FOLLOWING.child(currentUid).child(uid).observeSingleEvent(of: .value) {
            snapshot in
            
            let checkBool = snapshot.exists()
            
            completion(checkBool)
        }
    }
    
    
    
    func fetchUserStats(uid: String, completion: @escaping(UserRelationStats) -> Void) {
        
        REF_USER_FOLLOWERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            let followers = snapshot.children.allObjects.count
            
            REF_USER_FOLLOWING.child(uid).observeSingleEvent(of: .value) { snapshot in
                let following = snapshot.children.allObjects.count
                
                let stats = UserRelationStats(followers: followers, following: following)
                completion(stats)
            }
        }
    }
    
    
    func updateProfileImage(image: UIImage, completion: @escaping(URL?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let imageData = image.jpegData(compressionQuality: 0.3) else {return}
        
        let filename = NSUUID().uuidString
        let ref = STORAGE_PROFILE_IMAGES.child(filename)
        
        ref.putData(imageData, metadata: nil) { meta, error in
            ref.downloadURL {
                url, error in
                
                guard let profileImageUrl = url?.absoluteString else {return}
                
                let values = ["profileImageUrl": profileImageUrl]
                REF_USERS.child(uid).updateChildValues(values) {
                    err, ref in
                    completion(url)
                }
            }
        }
    }
    
    
    func saveUserData(user: User, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let values = [
            "fullname": user.fullName,
            "username": user.useername,
            "bio": user.bio
        ]
        
        REF_USERS.child(uid).updateChildValues(values) {
            err, ref in
            
            if let error = err {
                completion(error, nil)
                return
            }
            completion(nil, ref)

        }
    }
    
    
    func fetchUser(withUsername username: String, completion: @escaping(User) -> Void) {
        guard let currentUId = Auth.auth().currentUser?.uid else {return}
        
        REF_USER_USERNAMES.child(username).observeSingleEvent(of: .value) { snapshot in
            guard let uid = snapshot.value as? String else {return}
            self.fetchUser(uid: uid, completion: completion)
        }
    }
    
    
}
