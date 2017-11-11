//
//  CustomizedTextField.swift
//  AppIdeas
//
//  Created by Vandan Patel on 7/30/17.
//  Copyright © 2017 Vandan Patel. All rights reserved.
//

import UIKit


@IBDesignable
class CustomizedTextField: UITextField {
    
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
    
    func validateFullName(_ fullName: String) {
        backgroundColor = fullName.isEmpty ? redForInvalidInput : greenForValidInput
    }
    func validateUserName(_ userName: String) {
        backgroundColor = userName.isEmpty ? redForInvalidInput : greenForValidInput
    }
    
    func validateEmailOrPhone(_ emailOrPhone: String) {
        
        let alphaCharacters = CharacterSet.letters
        let alphaRange = emailOrPhone.rangeOfCharacter(from: alphaCharacters)
        
        if alphaRange != nil {
            let emailValidation = NSPredicate(format: "SELF MATCHES %@", Constants.emailRegEx)
            let result = emailValidation.evaluate(with: emailOrPhone)
            backgroundColor = result ? greenForValidInput : redForInvalidInput
        } else {
            let phoneNumberValidation = NSPredicate(format: "SELF MATCHES %@", Constants.phoneNumberRegEx)
            let result = phoneNumberValidation.evaluate(with: emailOrPhone)
            backgroundColor = result ? greenForValidInput : redForInvalidInput
        }
    }
    
    func validatePassword(_ password: String) {
        //Firebase only validates length of the password
        backgroundColor = password.count < 6 ? redForInvalidInput : greenForValidInput
    }
}
