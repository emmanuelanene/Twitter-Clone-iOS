//
//  UserCell.swift
//  TwitterClone
//
//  Created by Emmanuel Anene on 22/10/2024.
//

import UIKit
import SDWebImage


class UserCell: UITableViewCell {
    
    // Once we assign a User object to this variable, the configure() method will run. If no User object is assigned to it, then the configure method() won't run
    var user: User? {
        didSet { configure() }
    }
    
    // Profile Image - to add the profile image of the user
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        
        iv.setDimensions(width: 40, height: 40)
        iv.layer.cornerRadius = 40 / 2
        
        iv.backgroundColor = .twitterBlue
        
        return iv
    } ()
    
    
    // To add the username of the user
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Username"
        
        return label
    } ()
    
    
    
    // To add the fullname of the user
    private lazy var fullnameLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Fullname"
        
        return label
    } ()
    
    
    // Once a user object is parsed in, we want this function to run where the values of the username, fullname and the profilepic gets updated
    func configure() {
        guard let user = user else {return}
        
        profileImageView.sd_setImage(with: user.profileImageUrl)
        usernameLabel.text = user.useername
        fullnameLabel.text = user.fullName
        
    }
    
    
    // Override UITableViewCell init()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Add profile mage View and position it
        addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        // Stack the username and fullname vertically
        let stack = UIStackView(arrangedSubviews: [usernameLabel, fullnameLabel])
        stack.axis = .vertical
        stack.spacing = 2
        
        // add the stack to the subview
        addSubview(stack)
        stack.centerY(inView: self, leftAnchor: profileImageView.leftAnchor, paddingLeft: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
