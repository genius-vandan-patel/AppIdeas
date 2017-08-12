//
//  SignInVC.swift
//  AppIdeas
//
//  Created by Vandan Patel on 8/1/17.
//  Copyright © 2017 Vandan Patel. All rights reserved.
//

import UIKit
import Firebase

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailPasswordStackView: UIStackView!
    @IBOutlet weak var emailSignInButton: CustomizedButton!
    @IBOutlet weak var emailTextField: CustomizedTextField!
    @IBOutlet weak var passwordTextField: CustomizedTextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var signInButton: CustomizedButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        cancelButton.setImage(#imageLiteral(resourceName: "Cancel"), for: .normal)
        appIdeasAnimation.hideView(emailPasswordStackView, withAnimation: false)
        setTextFieldDelegate(for: [emailTextField, passwordTextField])
        signInButton.disableButtonWithAnimation(1.0, reducingAlphaTo: 0.5)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func emailSignInButtonTapped(_ sender: CustomizedButton) {
        appIdeasAnimation.hideView(emailSignInButton, withAnimation: true)
        appIdeasAnimation.showView(emailPasswordStackView, withAnimation: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if touch.view != emailPasswordStackView {
            appIdeasAnimation.hideView(emailPasswordStackView, withAnimation: true)
            appIdeasAnimation.showView(emailSignInButton, withAnimation: true)
        }
    }
    
    @IBAction func signInButtonTapped(_ sender: CustomizedButton) {
        showActivityIndicator()
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            guard let user = user else {
                self?.hideActivityIndicator()
                print("Can not retrieve user from Firebase")
                return
            }
            if error != nil {
                self?.hideActivityIndicator()
                appIdeasAnimation.shakeAnimation((self?.emailPasswordStackView)!)
                return
            }
            if !user.isEmailVerified {
                self?.hideActivityIndicator()
                self?.showAlertMessage(withTitle: "ERROR", message: "Your Email Is Not Verified", actions: [okAction])
            } else {
                self?.hideActivityIndicator()
                self?.performSegue(withIdentifier: SEGUES.SignInToIdeasTabBar, sender: nil)
            }
        }
    }
    
    func decideButtonStatus() {
        emailTextField.backgroundColor == greenForValidInput && passwordTextField.backgroundColor == greenForValidInput ? signInButton.enableButtonWithAnimation(0.5, increasingAlphaTo: 1.0) : signInButton.disableButtonWithAnimation(0.5, reducingAlphaTo: 0.5)
    }
}

extension SignInVC: UITextFieldDelegate {
    
    func setTextFieldDelegate(for views: [UITextField]) {
        for view in views {
            view.delegate = self
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        let sanitizedString = newString.trimmingCharacters(in: .whitespaces)
        
        if textField == emailTextField { emailTextField.validateEmailOrPhone(sanitizedString) }
        else if textField == passwordTextField { passwordTextField.validatePassword(sanitizedString) }
        
        decideButtonStatus()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.backgroundColor = redForInvalidInput
        decideButtonStatus()
        return true
    }
}






