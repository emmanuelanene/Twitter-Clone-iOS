//
//  ActionSheetViewModel.swift
//  TwitterClone
//
//  Created by Emmanuel Anene on 08/11/2024.
//

import UIKit

enum ActionSheetOptions {
    case follow(User)
    case unfollow(User)
    case report
    case delete
    
    
    var description: String {
        switch self {
            case .follow(let user): return "Follow @\(user.useername)"
            case .unfollow(let user): return "Unfollow @\(user.useername)"
            case .report: return "Report Tweet"
            case .delete: return "Delete Tweet"
        }
    }
}

struct ActionSheetViewModel {
    private let user: User
    
    var options: [ActionSheetOptions] {
        var result = [ActionSheetOptions]()
        
        if user.isCurrentUser {
            result.append(.delete)
        }
        
        else {
            let followOptions: ActionSheetOptions = user.isFollowed ? .unfollow(user) : .follow(user)
            result.append(followOptions)
        }
        
        result.append(.report)
        return result
    }
    
    
    
    init(user: User) {
        self.user = user
    }
}
