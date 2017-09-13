//
//  User.swift
//  AppIdeas
//
//  Created by Vandan Patel on 8/5/17.
//  Copyright © 2017 Vandan Patel. All rights reserved.
//

import Foundation

struct Innovator {
    var _fullName: String!
    var _ideas: [String]?
    var _comments: [String]?
    var _innovatorID: String
    
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
