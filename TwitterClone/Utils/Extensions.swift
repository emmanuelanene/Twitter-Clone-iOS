//
//  Extensions.swift
//  TwitterClone
//
//  Created by Emmanuel Anene on 05/11/2024.
//

import UIKit


extension UIView {
    func anchor(
        top: NSLayoutYAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        left: NSLayoutXAxisAnchor? = nil,
        right: NSLayoutXAxisAnchor? = nil,
        
        paddingTop: CGFloat = 0,
        paddingBottom: CGFloat = 0,
        paddingLeft: CGFloat = 0,
        paddingRight: CGFloat = 0,
        
        width: CGFloat? = nil,
        height: CGFloat? = nil
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    func center(
        inView view: UIView,
        yConstant: CGFloat? = 0
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yConstant!).isActive = true
    }
    
    
    
    
    
    
    func centerX(
        inView view: UIView,
        topAnchor: NSLayoutYAxisAnchor? = nil,
        paddingTop: CGFloat? = 0
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        if let topAnchor = topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: paddingTop!).isActive = true
        }
    }
    
    
    
    
    
    
    
    func centerY(
        inView view: UIView,
        leftAnchor: NSLayoutXAxisAnchor? = nil,
        paddingLeft: CGFloat? = 0,
        constant: CGFloat? = 0
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        if let leftAnchor = leftAnchor {
            self.leftAnchor.constraint(equalTo: leftAnchor, constant: paddingLeft!).isActive = true
        }
    }
    
    
    
    
    
    
    
    
    
    
    func setDimensions(
        width: CGFloat,
        height: CGFloat
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    
    
    
    
    func addConstraintsToFillView(
        _ view: UIView
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        
        anchor(
            top: view.topAnchor,
            bottom: view.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor
        )
    }
}








extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(
            red: red/255,
            green: green/255,
            blue: blue/255,
            alpha: 1
        )
            
    }
    
    static let twitterBlue = UIColor.rgb(red: 29, green: 161, blue: 242)
}
