//
//  DataStorage.swift
//  AppIdeas
//
//  Created by Vandan Patel on 8/5/17.
//  Copyright © 2017 Vandan Patel. All rights reserved.
//

import Foundation
import Firebase

struct IdeaStorage {
    static var ideas = [Idea]()
}

struct InnovatorStorage {
    static var innovators = [String:Innovator]()
}

struct CommentsStorage {
    static var commentIDs = [String]()
    static var comments = [Comment]()
}

struct DataStorage {
    
    static let sharedInstance = DataStorage()
    
    var databaseRef = Database.database().reference()
    let ideasRef = Database.database().reference().child("ideas")
    let commentsRef = Database.database().reference().child("comments")
    let innovatorRef = Database.database().reference().child(FIR.innovators)
    
    let myGroup = DispatchGroup()
    
    //post idea to the firebase
    func postIdea(idea: Idea) {
        let ideasRefWithID = Database.database().reference().child("ideas").childByAutoId()
        getCurrentInnovator().child("ideas").updateChildValues([ideasRefWithID.key: ""])
        ideasRefWithID.updateChildValues(idea.toDictionary())
    }
    
    func postComment(comment: Comment, ideaID: String) {
        let commentsRefWithID = Database.database().reference().child("comments").childByAutoId()
        getCurrentInnovator().child("comments").updateChildValues([commentsRefWithID.key: ""])
        ideasRef.child(ideaID).child("comments").updateChildValues([commentsRefWithID.key: ""])
        commentsRefWithID.updateChildValues(comment.toDictionary())
    }
    
    func getCurrentInnovator() -> DatabaseReference {
        return databaseRef.child(FIR.innovators).child((Auth.auth().currentUser?.uid)!)
    }
    
    func getCurrentUserID() -> String {
        return (Auth.auth().currentUser?.uid)!
    }
    
    //creates user dictionary so we can have fullName of user based on the uid
    func createInnovatorDicationary(completion: @escaping (Bool)->()) {
        innovatorRef.observe(.value) { (snapshot) in
            InnovatorStorage.innovators.removeAll()
            let enumerator = snapshot.children
            while let firInnovator = enumerator.nextObject() as? DataSnapshot {
                if let dictionary = firInnovator.value as? Dictionary<String, Any> {
                    guard let fullName = dictionary[FIR.fullName] as? String else {
                        completion(false)
                        return
                    }
                    let innovator = Innovator(fullName: fullName, ideas: nil, comments: nil, innovatorID: "")
                    InnovatorStorage.innovators[firInnovator.key] = innovator
                }
            }
            completion(true)
        }
    }
    
    //gets all the ideas from Firebase
    func getAllIdeas(completion: @escaping (Bool)->()) {
        ideasRef.observe(.value) { (snapshot) in
            IdeaStorage.ideas.removeAll()
            let enumerator = snapshot.children
            while let idea = enumerator.nextObject() as? DataSnapshot {
                if let dictionary = idea.value as? Dictionary<String, Any> {
                    guard let description = dictionary["ideaDescription"] as? String, let innovatorID = dictionary["innovatorID"] as? String, let likes = dictionary["likes"] as? Int else {
                        completion(false)
                        return
                    }
                    let ideaObject = Idea(_ideaID: idea.key, _ideaDescription: description, _likes: likes, _comments: nil, _innovatorID: innovatorID)
                    IdeaStorage.ideas.append(ideaObject)
                }
            }
            completion(true)
        }
    }
    
    //gets all the comments from Firebase
    func getAllComments(forIdea id: String, completion: @escaping (Bool?)->()) {
        ideasRef.child(id).child("comments").observe(.value) { (snapshot) in
            CommentsStorage.comments.removeAll()
            CommentsStorage.commentIDs.removeAll()
            let enumerator = snapshot.children
            while let commentID = enumerator.nextObject() as? DataSnapshot {
                CommentsStorage.commentIDs.append(commentID.key)
            }
            self.getComments(forCommentIDs: CommentsStorage.commentIDs, completion: { (comments) in
                completion(true)
            })
        }
    }
    
    func addLikeToIdea(withID id: String, andLikes likes: Int, completion: @escaping ()->()) {
        ideasRef.child(id).child("likes").setValue(likes) { (error, reference) in
            if error == nil {
                completion()
            }
        }
    }
    
    //get comment for given comment id
    func getComments(forCommentIDs IDs: [String], completion: @escaping ([Comment])->()) {
        for id in IDs {
            myGroup.enter()
            let query = commentsRef.queryOrderedByKey().queryEqual(toValue: id)
            query.observeSingleEvent(of: .value, with: { (snapshot) in
                let enumerator = snapshot.children
                while let comment = enumerator.nextObject() as? DataSnapshot {
                    if let dictionary = comment.value as? Dictionary<String, Any> {
                        guard let description = dictionary["commentDescription"] as? String, let name = dictionary["innovatorName"] as? String else {
                            return
                        }
                        let commentObject = Comment(_commentDescription: description, _innovatorName: name)
                        CommentsStorage.comments.append(commentObject)
                        self.myGroup.leave()
                    }
                }
                
            })
        }
        
        myGroup.notify(queue: DispatchQueue.main) {
            completion(CommentsStorage.comments)
        }
    }
}
