//
//  User.swift
//  AppIdeas
//
//  Created by Vandan Patel on 8/5/17.
//  Copyright © 2017 Vandan Patel. All rights reserved.
//

import Foundation

struct Innovator {
    private var _fullName: String!
    private var _ideas: [String]?
    private var _comments: [String]?
    private var _likedIdeas: [String]?
    private var _innovatorID: String
    private var _profilePicURL : String!
    
    var fullName: String! {
        get {
            return _fullName
        } set {
            _fullName = newValue
        }
    }
    
    var ideas: [String]? {
        get {
            return _ideas
        } set {
            _ideas = newValue
        }
    }
    
    var comments: [String]? {
        get {
            return _comments
        } set {
            _comments = newValue
        }
    }
    
    var innovatorID: String {
        get {
            return _innovatorID
        } set {
            _innovatorID = newValue
        }
    }
    
    var likedIdeas: [String]? {
        get {
            return _likedIdeas
        } set {
            _likedIdeas = newValue
        }
    }
    
    var profilePicURL: String! {
        get {
           return _profilePicURL
        } set {
            _profilePicURL = newValue
        }
    }
        
    init(fullName: String, ideas: [String]?, comments: [String]?, innovatorID: String, profilePicURL: String) {
        _fullName = fullName
        _ideas = ideas
        _comments = comments
        _innovatorID = innovatorID
        _profilePicURL = profilePicURL
    }
    
    func toDictionary() -> Dictionary<String, Any> {
        return [
            "fullName": fullName,
            "innovatorID": innovatorID,
            FIR.profilePicURL: profilePicURL ?? ""
        ]
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
