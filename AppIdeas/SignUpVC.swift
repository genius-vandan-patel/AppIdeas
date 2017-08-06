//
//  SignUpVC.swift
//  AppIdeas
//
//  Created by Vandan Patel on 8/2/17.
//  Copyright © 2017 Vandan Patel. All rights reserved.
//

import UIKit
import Firebase

//global variables
let redForInvalidInput = UIColor(red: 255/255, green: 153/255, blue: 153/255, alpha: 1.0)
let greenForValidInput = UIColor(red: 204/255, green: 255/255, blue: 153/255, alpha: 1.0)
let ideaStorage = DataStorage.sharedInstance.databaseRef
let okAction = UIAlertAction(title: "OK", style: .destructive, handler: nil)

class SignUpVC: UIViewController {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var signUpStackView: UIStackView!
    @IBOutlet weak var appIdeasLabel: UILabel!
    @IBOutlet weak var emailOrPhoneTextField: CustomizedTextField!
    @IBOutlet weak var userNameTextField: CustomizedTextField!
    @IBOutlet weak var passwordTextField: CustomizedTextField!
    @IBOutlet weak var fullNameTextField: CustomizedTextField!
    @IBOutlet weak var signUpButton: CustomizedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cancelButton.setImage(#imageLiteral(resourceName: "Cancel"), for: .normal)
        appIdeasAnimation.scaleInAnimation(appIdeasLabel, delay: 0.0, duration: 1.0)
        appIdeasAnimation.fadeInAnimation(signUpStackView, delay: 0.3, duration: 1.0)
        setTextFieldDelegate(for: [emailOrPhoneTextField, userNameTextField, passwordTextField, fullNameTextField])
        signUpButton.disableButtonWithAnimation(1.0, reducingAlphaTo: 0.6)
    }
    
    @IBAction func signUpButtonTapped(_ sender: CustomizedButton) {
        showActivityIndicator()
        guard let email = emailOrPhoneTextField.text, let password = passwordTextField.text ,let fullName = fullNameTextField.text, let username = userNameTextField.text else {
            hideActivityIndicator()
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
            if error != nil {
                self?.showAlertMessage(withTitle: "ERROR", message: error?.localizedDescription, actions: [okAction])
                self?.hideActivityIndicator()
                return
            }
            ideaStorage.child("innovators").child(username).setValue(["fullName": fullName], withCompletionBlock: { (error, reference) in
                if error != nil {
                    self?.showAlertMessage(withTitle: "Error", message: error?.localizedDescription, actions: [okAction])
                    self?.hideActivityIndicator()
                    return
                }
                self?.hideActivityIndicator()
                self?.performSegue(withIdentifier: SEGUES.SignUpToIdeasTabBar, sender: nil)
            })
        }
    }
    
    func decideButtonStatus() {
        fullNameTextField.backgroundColor == greenForValidInput && userNameTextField.backgroundColor == greenForValidInput && emailOrPhoneTextField.backgroundColor == greenForValidInput && passwordTextField.backgroundColor == greenForValidInput ? signUpButton.enableButtonWithAnimation(0.5, increasingAlphaTo: 1.0) : signUpButton.disableButtonWithAnimation(0.5, reducingAlphaTo: 0.6)
    }
}

extension SignUpVC: UITextFieldDelegate {
    
    func setTextFieldDelegate(for views: [UITextField]) {
        for view in views {
            view.delegate = self
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        let sanitizedString = newString.trimmingCharacters(in: .whitespaces)
        
        if textField == fullNameTextField { fullNameTextField.validateFullName(sanitizedString) }
        else if textField == userNameTextField { userNameTextField.validateUserName(sanitizedString) }
        else if textField == emailOrPhoneTextField { emailOrPhoneTextField.validateEmailOrPhone(sanitizedString) }
        else if textField == passwordTextField { passwordTextField.validatePassword(sanitizedString) }
        
        //textField.backgroundColor = sanitizedString.isEmpty ?  redForInvalidInput : greenForValidInput
        decideButtonStatus()
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.backgroundColor = redForInvalidInput
        decideButtonStatus()
        return true
    }
}
