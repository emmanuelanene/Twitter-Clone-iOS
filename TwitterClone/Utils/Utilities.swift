//
//  Utilities.swift
//  TwitterClone
//
//  Created by Emmanuel Anene on 05/11/2024.
//

import UIKit

class Utilities {
    // Function to take image and text as input and return a UIView
    func inputContainerView(
        withImage image: UIImage,
        textField: UITextField
    ) -> UIView {
        // Overall view to hold the image, text and bottom divider line. 50cm tall
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Image to be added into the UIView
        let iv = UIImageView()
        iv.image = image
        
        view.addSubview(iv)
        
        iv.anchor(
            top: view.topAnchor,
            bottom: view.bottomAnchor,
            paddingLeft: 8,
            paddingRight: 8
        )
        
        iv.setDimensions(
            width: 24,
            height: 24
        )
        
        
        // Text to be added into the UIView
        view.addSubview(textField)
        
        textField.anchor(
            bottom: view.bottomAnchor,
            left: iv.rightAnchor,
            right: view.rightAnchor,
            paddingBottom: 8,
            paddingLeft: 8
        )
        
        
        let dividerView = UIView()
        
        dividerView.backgroundColor = .white
        view.addSubview(dividerView)
        
        dividerView.anchor(
            bottom: view.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingLeft: 8,
            height: 0.75
        )
        
        return view
    }
    
    
    
    
    
    
    
    
    
    
    func textField(
        withPlaceholder placeholder: String
    ) -> UITextField {
        let textField = UITextField()
        
        textField.textColor = .white
        textField.font = UIFont.systemFont(ofSize: 16)
        
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.white
            ]
        )
        
        return textField
    }
    
    
    
    
    
    
    
    
    
    
    func attributedButton(
        _ firstPart: String,
        _ secondPart: String
    ) -> UIButton {

        let attributedTitle = NSMutableAttributedString(
            string: firstPart,
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
                NSAttributedString.Key.foregroundColor: UIColor.white
            ]
        )
        
        
        attributedTitle.append(NSAttributedString(
            string: secondPart,
            attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor: UIColor.white
            ]
        ))
        
        
        let button = UIButton(type: .system)
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        return button
    }
}
