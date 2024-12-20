//
//  TweetService.swift
//  TwitterClone
//
//  Created by Emmanuel Anene on 08/11/2024.
//

import UIKit
import Firebase

struct TweetService {
    static let shared = TweetService()
    
    
    func uploadTweet(caption: String, type: UploadTweetConfiguration, completion: @escaping(DatabaseCompletion)) {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        var values = [
            "uid": uid,
            "timeStamp": Int(NSDate().timeIntervalSince1970),
            "likes": 0,
            "retweets": 0,
            "caption": caption
        ] as [String: Any]
        
        
        switch type {
            case .tweet:
            
            REF_TWEETS.childByAutoId().updateChildValues(values) { error, tweetRef in
                guard let tweetID = tweetRef.key else {return}
                
                
                REF_USER_TWEETS.child(uid).updateChildValues([tweetID: 1]) { error, tweetRef in
                    if let error = error {
                        completion(error, nil)
                        return
                    }
                    completion(nil, tweetRef)
                }
            }
        
                
            case .reply(let tweet):
            
            values["replyingTo"] = tweet.user.useername
            
            REF_TWEET_REPLIES.child(tweet.tweetID).childByAutoId().updateChildValues(values) {error, replyRef in
                // This ensures replyID is not nil before continuing.
                guard let replyID = replyRef.key else {return}
                
                REF_USER_REPLIES.child(uid).updateChildValues([tweet.tweetID: replyID]) { error, res in
                    if let error = error {
                        completion(error, nil)
                        return
                    }
                    completion(nil, res)
                }
            }
        }
    }
    
    
    
    func fetchTweet(withTweetID tweetID: String, completion: @escaping(Tweet) -> Void) {
        guard let currentUId = Auth.auth().currentUser?.uid else {return}
        
        REF_TWEETS.child(tweetID).observeSingleEvent(of: .value) { snapshot in
            
            guard let dictionary = snapshot.value as? [String: AnyObject] else {return}
            guard let uid = dictionary["uid"] as? String else {return}
            
            UserService.shared.fetchUser(uid:uid) { user in
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                completion(tweet)
            }
        }
    }
    
    
    
    func fetchTweets(completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUid).observe(.childAdded) {
            snapshot in
            let followingUid = snapshot.key
            
            REF_USER_TWEETS.child(followingUid).observe(.childAdded) { snapshot in
                let tweetID = snapshot.key
                
                self.fetchTweet(withTweetID: tweetID) { tweet in
                    tweets.append(tweet)
                    completion(tweets)
                }
            }
        }
        
        
        REF_USER_TWEETS.child(currentUid).observe(.childAdded) { snapshot in
            let tweetID = snapshot.key
            
            self.fetchTweet(withTweetID: tweetID) { tweet in
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    
    
    func fetchTweets(forUser user: User, completion: @escaping([Tweet]) -> Void) {

        var tweets = [Tweet]()

        REF_USER_TWEETS.child(user.uid).observe(.childAdded) { snapshot in

            let tweetID = snapshot.key

            self.fetchTweet(withTweetID: tweetID) { tweet in
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    
    
    
    func fetchReplies(forUser user: User, completion: @escaping([Tweet]) -> Void) {
        var replies = [Tweet]()

        REF_USER_REPLIES.child(user.uid).observe(.childAdded) { snapshot in
            let tweetKey = snapshot.key
            guard let replyKey = snapshot.value as? String else { return }
            
            REF_TWEET_REPLIES.child(tweetKey).child(replyKey).observeSingleEvent(of: .value) { snapshot in
                guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
                guard let uid = dictionary["uid"] as? String else { return }
                let replyID = snapshot.key
                                
                UserService.shared.fetchUser(uid: uid) { user in
                    let reply = Tweet(user: user, tweetID: replyID, dictionary: dictionary)
                    replies.append(reply)
                    completion(replies)
                }
            }
        }
    }
    
    
    
    
    
    func fetchReplies(forTweet tweet: Tweet, completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        REF_TWEET_REPLIES.child(tweet.tweetID).observe(.childAdded) { snapshot in

            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let tweetID = snapshot.key
            
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    
    
    
    func fetchLikes(forUser user: User, completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        REF_USER_LIKES.child(user.uid).observe(.childAdded) { snapshot in
            let tweetID = snapshot.key
            
            self.fetchTweet(withTweetID: tweetID) { likedTweet in
                var tweet = likedTweet
                tweet.didLike = true
                
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    
    
    func likeTweet(tweet: Tweet, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        

        let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
        
        REF_TWEETS.child(tweet.tweetID).child("likes").setValue(likes)
        
        
        
        // UNLIKING A TWEET
        if tweet.didLike {
            REF_USER_LIKES.child(uid).child(tweet.tweetID).removeValue { (err, ref) in
                REF_TWEET_LIKES.child(tweet.tweetID).removeValue(completionBlock: completion)
            }
        }
        // LIKING A TWEET
        else {
            REF_USER_LIKES.child(uid).updateChildValues([tweet.tweetID: 1]) { (err, ref) in
                REF_TWEET_LIKES.child(tweet.tweetID).updateChildValues([uid: 1], withCompletionBlock: completion)
            }
        }
    }
    
    
    
    
    func checkIfUserLikedTweet(_ tweet: Tweet, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_LIKES.child(uid).child(tweet.tweetID).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
}
