//
//  AuthService.swift
//  TwitterClone
//
//  Created by Emmanuel Anene on 08/11/2024.
//

import UIKit
import Firebase


struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService {
    static let shared = AuthService()
    
    func logUserIn(
        withEmail email: String,
        password: String,
        completion: @escaping (Bool, Error?) -> Void
    ) {
        Auth.auth().signIn(
            withEmail: email,
            password: password
        ) { result, error in
            completion(false, error)
            return
        }
    }
    
    
    func registerUser (
        credentials: AuthCredentials,
        completion: @escaping (DatabaseReference?, Error?) -> Void
    ) {
        let email = credentials.email
        let password = credentials.password
        let username = credentials.username
        let fullname = credentials.fullname
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else {return}
        
        
        let filename = NSUUID().uuidString
        let storageRef = STORAGE_PROFILE_IMAGES.child(filename)
        
        storageRef.putData(imageData, metadata: nil) {
            (meta, error) in
            
            if let error = error {
                completion(nil, error)
                return
            }
            
            storageRef.downloadURL {
                (url, error) in
                
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                guard let profileImageUrl = url?.absoluteString else {return}
                
                Auth.auth().createUser(withEmail: email, password: password) {
                    (result, error) in
                    
                    if let error = error {
                        print("DEBUG: Error is \(error.localizedDescription)")
                        completion(nil, error)
                        return
                    }
                    
                    
                    // Trying to use the created user detail to get the UID from the just created user detail. This is jsut to confirm that the user was created
                    guard let uid = result?.user.uid else {return}
                    
                    
                    // Since we successfully confirmed the user was created, now we want to save the entire details of the newly made user in the DB. First we compile all the details into an array
                    let values = [
                        "email": email,
                        "username": username,
                        "fullname": fullname,
                        "profileImageUrl": profileImageUrl
                    ]
                    
                    REF_USERS.child(uid).updateChildValues(values) {
                        (err, ref) in
                        
                        if let err = error{
                            print("DEBUG: Error is \(err.localizedDescription)")
                            return
                        }
                        
                        REF_USER_USERNAMES.updateChildValues([username: uid])
                        completion(ref, nil)
                        
                        
                        /*
                         completion(ref, nil):

                         This is used when the process completes successfully.
                         ref represents the database reference of the successfully created user, and nil is used for the error parameter, indicating success.
                         
                         
                         completion(nil, error):

                         This form is used when an error occurs, typically before reaching the database write.
                         We return nil for the DatabaseReference because the process didn’t succeed, and there’s no valid reference to return.
                         */
                    }
                }
            }
            
        }
    }
}
