//
//  TweetCell.swift
//  TwitterClone
//
//  Created by Emmanuel Anene on 22/10/2024.
//

import UIKit
import ActiveLabel
import SDWebImage


protocol TweetCellDelegate: class {
    func handleProfileImageTapped(_ cell: TweetCell)
    func handleReplyTapped(_ cell: TweetCell)
    func handleLikeTapped(_ cell: TweetCell)
    func handleFetchUser(withUsername username: String)
}


class TweetCell: UICollectionViewCell {
    // This is like us creating an instance of the protocol. ALWAYS USE "WEAK".
    weak var delegate: TweetCellDelegate?
    
    // This is an optional tweet variable. Once a Tweet object is assigned to this variable the function within (i.e. configure()) will be run automatically. We defined this function below
    var tweet: Tweet? {
        didSet{configure()}
    }
    

    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48 / 2
        iv.backgroundColor = .twitterBlue
        
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(handleProfileImageTapped)
        )
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        
        return iv
    } ()
    
    
    private let replyLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.mentionColor = .twitterBlue
        return label
    } ()
    
    
    private let captionLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.mentionColor = .twitterBlue
        label.hashtagColor = .twitterBlue
        return label
    } ()
    
    
    
    // BUTTONS FOR WHEN A TWEET IS VIEWED (COMMENT, LIKE, RETWEET AND SHARE BUTTON.
    func createButton(withImageName imageName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        return button
    }
    
    private lazy var commentButton: UIButton = {
        let button = createButton(withImageName: "comment")
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetButton: UIButton = {
        let button = createButton(withImageName: "retweet")
        button.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = createButton(withImageName: "like")
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = createButton(withImageName: "share")
        button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
        return button
    }()
    // END OF BUTTONS FOR WHEN A TWEET IS VIEWED (COMMENT, LIKE, RETWEET AND SHARE BUTTON.
    
    
    
    
    
    // WHAT HAPPENS ON TAPPING THE like, share, retweet... buttons? Delegate refers to the "protocol" and it allows us to access the functions of the protocol
    @objc func handleProfileImageTapped() {
        delegate?.handleProfileImageTapped(self)
    }
    
    @objc func handleCommentTapped() {
        delegate?.handleReplyTapped(self)
    }
    
    @objc func handleRetweetTapped() {
        
    }
    
    @objc func handleLikeTapped() {
        delegate?.handleLikeTapped(self)
    }
    
    @objc func handleShareTapped() {
        
    }
    
    private let infoLabel = UILabel()
    
    
    
    
    
    // SET UP CONFIGURE FOR ""didSet{ configure() }"" above. This function will run once a value is provided for the "tweet" variable.
    func configure() {
        guard let tweet = tweet else { return }
        let viewModel = TweetViewModel(tweet: tweet)
        
        captionLabel.text = tweet.caption
        
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        
        // This sets the attributedText property of infoLabel (probably another UILabel) to userInfoText from the viewModel. userInfoText is likely an NSAttributedString
        infoLabel.attributedText = viewModel.userInfoText
        infoLabel.font = UIFont.systemFont(ofSize: 14)
        
        likeButton.tintColor = viewModel.likeButtonTintColor
        likeButton.setImage(viewModel.likeButtonImage, for: .normal)
        
        replyLabel.isHidden = viewModel.shouldHideReplyLabel
        replyLabel.text = viewModel.replyText
    }
    

    


    
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        let captionStack = UIStackView(arrangedSubviews: [infoLabel, captionLabel])
        captionStack.axis = .vertical
        captionStack.distribution = .fillProportionally
        captionStack.spacing = 4
        
        
        
        let imageCaptionStack = UIStackView(arrangedSubviews: [profileImageView, captionStack])
        imageCaptionStack.distribution = .fillProportionally
        imageCaptionStack.spacing = 12
        imageCaptionStack.alignment = .leading
        
        
        
        let stack = UIStackView(arrangedSubviews: [replyLabel, imageCaptionStack])
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillProportionally
        
        addSubview(stack)
        stack.anchor(
            top: topAnchor,
            left: leftAnchor,
            right: rightAnchor,
            paddingTop: 4,
            paddingLeft: 12,
            paddingRight: 12
        )
        
        
        
        // Stack the buttons (like, share, retweet, etc) horizontally
        let actionStack = UIStackView(
            arrangedSubviews: [commentButton, retweetButton, likeButton, shareButton]
        )
        actionStack.axis = .horizontal
        actionStack.spacing = 72
        
        // Add the stack to the view and setup it's positioning
        addSubview(actionStack)
        actionStack.centerX(inView: self)
        actionStack.anchor(
            bottom: bottomAnchor,
            paddingBottom: 8
        )
        
        
        
        // This is the line separator that will serve as a demarkator at the bottom of the tweet. Create the UIView for the line, add it to the subview and define it's positioning and height
        let underlineView = UIView()
        underlineView.backgroundColor = .systemGroupedBackground
        addSubview(underlineView)
        underlineView.anchor(
            bottom: bottomAnchor,
            left: leftAnchor,
            right: rightAnchor,
            height: 1
        )
        
        configureMentionHandler()
    }
    
    
    
    
    // If there's a mention in the captionLabel, I want the mention will be able to get clicked cause we're using "ActiveLabel" and when it's clicked we want to call the protocol function "handleFetchUser"
    func configureMentionHandler() {
        captionLabel.handleMentionTap { username in
            self.delegate?.handleFetchUser(withUsername: username)
        }
    }
    
    

    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
