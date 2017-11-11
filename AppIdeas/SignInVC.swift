//
//  SignInVC.swift
//  AppIdeas
//
//  Created by Vandan Patel on 8/1/17.
//  Copyright © 2017 Vandan Patel. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import GoogleSignIn

class SignInVC: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {

    
    @IBOutlet weak var emailPasswordStackView: UIStackView!
    @IBOutlet weak var emailSignInButton: CustomizedButton!
    @IBOutlet weak var emailTextField: CustomizedTextField!
    @IBOutlet weak var passwordTextField: CustomizedTextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var signInButton: CustomizedButton!
    @IBOutlet weak var facebookButton: CustomizedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cancelButton.setImage(#imageLiteral(resourceName: "Cancel"), for: .normal)
        appIdeasAnimation.hideView(emailPasswordStackView, withAnimation: false)
        setTextFieldDelegate(for: [emailTextField, passwordTextField])
        signInButton.disableButtonWithAnimation(1.0, reducingAlphaTo: 0.5)
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //delegate method for Google Sign-In
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        showActivityIndicator()
        if error != nil {
            hideActivityIndicator()
            print("Error Signing In With Google : " , error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let googleCredentials = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        let fullName = user.profile.name
        firebaseSignIn(withCredentials: googleCredentials) { [weak self] (user, success) in
            if success {
                ideaStorage.child(FIR.innovators).child(user.uid).setValue([FIR.fullName: fullName, FIR.authMethod: FIR.google, FIR.profilePicURL: ""], withCompletionBlock: { (error, reference) in
                    self?.hideActivityIndicator()
                    if error != nil {
                        print("Error uploading google information to Firebase : ", error?.localizedDescription as Any)
                        return
                    }
                    self?.performSegue(withIdentifier: SEGUES.SignInToIdeasTabBar, sender: nil)
                })
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
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
                self?.markUserLoggedIn()
                self?.performSegue(withIdentifier: SEGUES.SignInToIdeasTabBar, sender: nil)
            }
        }
    }
    
    
    @IBAction func facebookButtonTapped(_ sender: CustomizedButton) {
        appIdeasAnimation.buttonClickAnimation(for: sender) { (success) in
            if success {
                let facebookManager = FBSDKLoginManager()
                facebookManager.logIn(withReadPermissions: ["email", "public_profile"], from: self) { [weak self] (result, error) in
                    self?.showActivityIndicator()
                    if error != nil {
                        self?.showAlertMessage(withTitle: "Facebook LogIn Failed", message: "Can not authenticate using Facebook", actions: [okAction])
                        return
                    }
                    FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"name"]).start(completionHandler: { (connection, result, error) in
                        if error != nil {
                            self?.hideActivityIndicator()
                            print("Failed To Start Graph Request", error?.localizedDescription as Any)
                            return
                        }
                        guard let facebookTokenString = FBSDKAccessToken.current().tokenString, let result = result as? Dictionary<String, Any>  else {
                            self?.hideActivityIndicator()
                            return }
                        let facebookCredentials = FacebookAuthProvider.credential(withAccessToken: facebookTokenString)
                        self?.firebaseSignIn(withCredentials: facebookCredentials, completion: { (user, success) in
                            if success {
                                ideaStorage.child(FIR.innovators).child(user.uid).setValue([FIR.fullName: result["name"], FIR.authMethod: FIR.facebook, FIR.profilePicURL: ""], withCompletionBlock: { (error, reference) in
                                    self?.hideActivityIndicator()
                                    if error != nil {
                                        print("Error uploading information to Firebase Database : ", error?.localizedDescription as Any)
                                        return
                                    }
                                    print("Information uploaded to Firebase")
                                    self?.performSegue(withIdentifier: SEGUES.SignInToIdeasTabBar, sender: nil)
                                })
                            } else {
                                self?.hideActivityIndicator()
                            }
                        })
                    })
                }
            }
        }
    }
    
    
    @IBAction func googleTapped(_ sender: CustomizedButton) {
        appIdeasAnimation.buttonClickAnimation(for: sender) { (success) in
            if success {
                GIDSignIn.sharedInstance().signIn()
            }
        }
    }
    
    func firebaseSignIn(withCredentials credentials: AuthCredential, completion: @escaping (User, Bool)->()) {
        Auth.auth().signIn(with: credentials) { [weak self] (user, error) in
            guard let user = user else { return }
            if error != nil {
                print("Facebook LogIn With Firebase Failed : ", error?.localizedDescription as Any)
                completion(user, false)
                return
            }
            print("Firebase Log In Successful!")
            self?.markUserLoggedIn()
            completion(user, true)
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






