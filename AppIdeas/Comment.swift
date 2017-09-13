//
//  Comment.swift
//  AppIdeas
//
//  Created by Vandan Patel on 8/16/17.
//  Copyright © 2017 Vandan Patel. All rights reserved.
//

import Foundation

struct Comment {
    var _commentDescription: String!
    var _innovatorName: String!
    
    var commentDescription: String! {
        get {
            return _commentDescription
        } set {
            _commentDescription = newValue
        }
    }
    
    var innovatorName: String! {
        get {
            return _innovatorName
        } set {
            _innovatorName = newValue
        }
    }
    
    func toDictionary() -> Dictionary<String, Any> {
        return [
            "commentDescription": commentDescription,
            "innovatorName": innovatorName
        ]
    }
}
