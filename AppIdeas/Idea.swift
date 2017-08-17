//
//  Idea.swift
//  AppIdeas
//
//  Created by Vandan Patel on 8/16/17.
//  Copyright © 2017 Vandan Patel. All rights reserved.
//

import Foundation

struct Idea {
    var ideaDescription: String!
    var likes: Int!
    var dislikes: Int!
    var date: Date!
    var comments: [Comment]?
    var innovator: Innovator!
}
