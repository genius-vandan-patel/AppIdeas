//
//  CustomizedUITextView.swift
//  AppIdeas
//
//  Created by Vandan Patel on 8/20/17.
//  Copyright © 2017 Vandan Patel. All rights reserved.
//

import UIKit

@IBDesignable
class CustomizedUITextView: UITextView {
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
}
