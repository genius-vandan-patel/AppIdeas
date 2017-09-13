//
//  Idea.swift
//  AppIdeas
//
//  Created by Vandan Patel on 8/16/17.
//  Copyright © 2017 Vandan Patel. All rights reserved.
//

import Foundation

struct Idea {
    var _ideaID: String?
    var _ideaDescription: String!
    var _likes: Int!
    var _comments: [Comment]?
    var _innovatorID: String
    
    var ideaDescription: String! {
        get {
            return _ideaDescription
        } set {
            _ideaDescription = newValue
        }
    }
    
    var likes: Int! {
        get {
            return _likes
        } set {
            _likes = newValue
        }
    }
    
    var comments: [Comment]? {
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
    
    var ideaID: String? {
        get {
            return _ideaID
        } set {
            _ideaID = newValue
        }
    }
    
    func toDictionary() -> Dictionary<String, Any> {
        return [
            "ideaDescription": ideaDescription,
            "likes": likes,
            "innovatorID": innovatorID
        ]
    }
}
