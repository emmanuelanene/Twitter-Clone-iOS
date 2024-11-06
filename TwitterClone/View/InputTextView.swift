//
//  InputTextView.swift
//  TwitterClone
//
//  Created by Emmanuel Anene on 22/10/2024.
//

import UIKit

class inputTextView: UITextView {
    
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "What's happening"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    } ()
    
    
    override init(
        frame: CGRect,
        textContainer: NSTextContainer?
    ) {
        super.init(
            frame: frame,
            textContainer: textContainer
        )
        
        backgroundColor = .white
        font = UIFont.systemFont(ofSize: 16)
        isScrollEnabled = false
        heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        addSubview(placeholderLabel)
        placeholderLabel.anchor(
            top: topAnchor,
            left: leftAnchor,
            paddingTop: 8,
            paddingLeft: 4
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleTextInputChange),
            name: UITextView.textDidChangeNotification,
            object: nil
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleTextInputChange() {
        placeholderLabel.isHidden = !text?.isEmpty
    }
}
