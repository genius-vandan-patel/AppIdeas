//
//  CustomizedUIImageView.swift
//  AppIdeas
//
//  Created by Vandan Patel on 8/19/17.
//  Copyright © 2017 Vandan Patel. All rights reserved.
//

import UIKit

@IBDesignable
class CustomizedUIImageView: UIImageView {
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
}
