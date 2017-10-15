//
//  Constants.swift
//  AppIdeas
//
//  Created by Vandan Patel on 8/4/17.
//  Copyright © 2017 Vandan Patel. All rights reserved.
//

import UIKit

struct Constants {
    static let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
    
    static let phoneNumberRegEx = "^\\(?\\d{3}\\)?-?\\d{3}-?\\d{4}$"
}

struct FIR {
    static let innovators = "innovators"
    static let ideas = "ideas"
    static let provider = "provider"
    static let fullName = "fullName"
    static let authMethod = "authMedhod"
    static let email = "email"
    static let facebook = "facebook"
    static let facebookName = "faceBookName"
    static let googleName = "googleName"
    static let google = "google"
    static let favoritedIdeas = "favoritedIdeas"
}

struct SEGUES {
    static let SignInToIdeasTabBar = "SignInToIdeasTabBar"
    static let HomeToComments = "FromHomeToComments"
    static let YourIdeasToComments = "FromYourIdeasToComments"
}

struct Storyboard {
    static let landingPage = "landingPage"
    static let tabBar = "ideasTabBar"
}
