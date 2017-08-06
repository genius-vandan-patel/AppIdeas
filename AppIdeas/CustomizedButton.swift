//
//  CustomizedButton.swift
//  AppIdeas
//
//  Created by Vandan Patel on 7/30/17.
//  Copyright © 2017 Vandan Patel. All rights reserved.
//

import UIKit

@IBDesignable
class CustomizedButton: UIButton {
        
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = .black {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var shadowColor: UIColor = .black {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.0 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize.zero {
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0.0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    func disableButtonWithAnimation(_ duration: Double, reducingAlphaTo alpha: CGFloat) {
        self.isUserInteractionEnabled = false
        UIView.animate(withDuration: duration) { [weak self] in
            self?.alpha = alpha
        }
    }
    
    func enableButtonWithAnimation(_ duration: Double, increasingAlphaTo alpha: CGFloat) {
        self.isUserInteractionEnabled = true
        UIView.animate(withDuration: duration) { [weak self] in
            self?.alpha = alpha
        }
    }
}
