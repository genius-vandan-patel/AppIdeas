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
        
    init(fullName: String, ideas: [String]?, comments: [String]?, innovatorID: String) {
        _fullName = fullName
        _ideas = ideas
        _comments = comments
        _innovatorID = innovatorID
    }
    
    func toDictionary() -> Dictionary<String, Any> {
        return [
            "fullName": fullName,
            "innovatorID": innovatorID
        ]
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
