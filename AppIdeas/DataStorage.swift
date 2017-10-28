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
    static var yourIdeas = [Idea]()
    static var yourIdeasIDs = [String]()
    static var yourFavoriteIdeas = [Idea]()
}

struct InnovatorStorage {
    static var innovators = [String : Innovator]()
    static var likedIdeas = [String: Any]()
    static var favoritedIdeas = [String: Any]()
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
    let groupForLikes = DispatchGroup()
    let groupForUserIdeas = DispatchGroup()
    let groupForFavorites = DispatchGroup()
    
    //post idea to the firebase
    func postIdea(idea: Idea, completion: @escaping ()->()) {
        let ideasRefWithID = Database.database().reference().child("ideas").childByAutoId()
        getCurrentInnovator().child("ideas").updateChildValues([ideasRefWithID.key: ""])
        ideasRefWithID.updateChildValues(idea.toDictionary())
        ideasRefWithID.updateChildValues(idea.toDictionary()) { (error, _) in
            if error == nil { completion() }
        }
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
    func createInnovatorDictionary(completion: @escaping (Bool)->()) {
        innovatorRef.observeSingleEvent(of: .value) { (snapshot) in
            InnovatorStorage.innovators.removeAll()
            let enumerator = snapshot.children
            while let firInnovator = enumerator.nextObject() as? DataSnapshot {
                if let dictionary = firInnovator.value as? Dictionary<String, Any> {
                    guard let fullName = dictionary[FIR.fullName] as? String, let profilePicURL = dictionary[FIR.profilePicURL] as? String else {
                        completion(false)
                        return
                    }
                    let innovator = Innovator(fullName: fullName, ideas: nil, comments: nil, innovatorID: "", profilePicURL: profilePicURL)
                    InnovatorStorage.innovators[firInnovator.key] = innovator
                }
            }
            completion(true)
        }
    }
    
    //get liked ideas by innovator 
    func getLikedIdeasByInnovator(for id: String, completion: @escaping (Bool)->()) {
        innovatorRef.child(id).child("likedIdeas").observeSingleEvent(of: .value) { (snapshot) in
            self.groupForLikes.enter()
            InnovatorStorage.likedIdeas.removeAll()
            let enumerator = snapshot.children
            while let child = enumerator.nextObject() as? DataSnapshot {
                InnovatorStorage.likedIdeas[child.key] = ""
            }
            self.groupForLikes.leave()
        }
        groupForLikes.notify(queue: .main) {
            completion(true)
        }
    }
    
    //gets current user's ideas
    func getIdeasForCurrentUser(completion: @escaping (Bool)->()) {
        getCurrentInnovator().child("ideas").observe(.value) { (snapshot) in
            IdeaStorage.yourIdeasIDs.removeAll()
            IdeaStorage.yourIdeas.removeAll()
            let enumerator = snapshot.children
            while let idea = enumerator.nextObject() as? DataSnapshot {
                IdeaStorage.yourIdeasIDs.append(idea.key)
            }
            self.getIdeas(forIdeaIDs: IdeaStorage.yourIdeasIDs, completion: { (success) in
                if success {
                    completion(true)
                }
            })
        }
    }
    
    //get favorited ideas by innovator [To Do]
    func getFavoritedIdeasByInnovator(for id: String, completion: @escaping (Bool)->()) {
        innovatorRef.child(id).child(FIR.favoritedIdeas).observeSingleEvent(of: .value) { (snapshot) in
            InnovatorStorage.favoritedIdeas.removeAll()
            let enumerator = snapshot.children
            while let child = enumerator.nextObject() as? DataSnapshot {
                InnovatorStorage.favoritedIdeas[child.key] = []
            }
            completion(true)
        }
    }
    
    func getIdeas(forIdeaIDs ids : [String], completion: @escaping (Bool)->()) {
        for id in ids {
            groupForUserIdeas.enter()
            let query = ideasRef.queryOrderedByKey().queryEqual(toValue: id)
            query.observeSingleEvent(of: .value, with: { (snapshot) in
                let enumerator = snapshot.children
                while let idea = enumerator.nextObject() as? DataSnapshot {
                    if let dictionary = idea.value as? Dictionary<String, Any> {
                        guard let description = dictionary["ideaDescription"] as? String, let innovatorID = dictionary["innovatorID"] as? String, let likes = dictionary["likes"] as? Int else {
                            completion(false)
                            return
                        }
                        let ideaObject = Idea(_ideaID: idea.key, _ideaDescription: description, _likes: likes, _comments: nil, _innovatorID: innovatorID)
                        IdeaStorage.yourIdeas.append(ideaObject)
                        self.groupForUserIdeas.leave()
                    } else {
                        completion(false)
                    }
                }
            })
        }
        groupForUserIdeas.notify(queue: .main) {
            completion(true)
        }
    }
    
    func getFavoriteIdeasForInnovator(forIdeaIDs ids : [String], completion: @escaping (Bool)->()) {
        for id in ids {
            groupForUserIdeas.enter()
            let query = ideasRef.queryOrderedByKey().queryEqual(toValue: id)
            query.observeSingleEvent(of: .value, with: { (snapshot) in
                let enumerator = snapshot.children
                while let idea = enumerator.nextObject() as? DataSnapshot {
                    if let dictionary = idea.value as? Dictionary<String, Any> {
                        guard let description = dictionary["ideaDescription"] as? String, let innovatorID = dictionary["innovatorID"] as? String, let likes = dictionary["likes"] as? Int else {
                            completion(false)
                            return
                        }
                        let ideaObject = Idea(_ideaID: idea.key, _ideaDescription: description, _likes: likes, _comments: nil, _innovatorID: innovatorID)
                        IdeaStorage.yourFavoriteIdeas.append(ideaObject)
                        self.groupForUserIdeas.leave()
                    } else {
                        completion(false)
                    }
                }
            })
        }
        groupForUserIdeas.notify(queue: .main) {
            completion(true)
        }
        
    }
    
    func getFavoriteIdeas(forIdeaIDs ids : [String], completion: @escaping (Bool)->()) {
        let userID = Auth.auth().currentUser?.uid
        for id in ids {
            let query = innovatorRef.child(userID!).child(FIR.favoritedIdeas).queryOrderedByKey().queryEqual(toValue: id)
            query.observeSingleEvent(of: .value, with: { (snapshot) in
                self.groupForFavorites.enter()
                let enumerator = snapshot.children
                while let favIdeaID = enumerator.nextObject() as? DataSnapshot {
                    InnovatorStorage.favoritedIdeas[favIdeaID.key] = ""
                    self.groupForFavorites.leave()
                }
            })
        }
        
        groupForFavorites.notify(queue: .main) {
            let keys = Array(InnovatorStorage.favoritedIdeas.keys)
            IdeaStorage.yourFavoriteIdeas.removeAll()
            self.getFavoriteIdeasForInnovator(forIdeaIDs: keys, completion: { (success) in
                if success {
                    completion(true)
                }
            })
        }
    }
    
    //gets all the ideas from Firebase
    func getAllIdeas(completion: @escaping (Bool)->()) {
        ideasRef.observeSingleEvent(of: .value) { (snapshot) in
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
    
    func addLikedToInnovator(withInnovatorID id: String, andIdeaID ideaID: String, completion: @escaping ()->()) {
        innovatorRef.child(id).child("likedIdeas").updateChildValues([ideaID: ""]) { (error, reference) in
            if error == nil {
                completion()
            }
        }
    }
    
    func addFavoritedToInnovator(withInnovatorID id: String, andIdeaID ideaID: String, completion: @escaping ()->()) {
        innovatorRef.child(id).child(FIR.favoritedIdeas).updateChildValues([ideaID: ""]) { (error, _) in
            if error == nil {
                completion()
            } else {
                print("There is an error adding idea to favorites in Firebase")
            }
        }
    }
    
    func removeFavoritedFromInnovator(withID id: String, completion: @escaping ()->()) {
        let userID = Auth.auth().currentUser?.uid
        innovatorRef.child(userID!).child(FIR.favoritedIdeas).child(id).removeValue { (error, _) in
            if error == nil {
                completion()
            }
        }
    }
    
    func dislikeIdea(withID id: String, completion: @escaping ()->()) {
        let userID = Auth.auth().currentUser?.uid
        innovatorRef.child(userID!).child("likedIdeas").child(id).removeValue { (error, reference) in
            if error == nil {
                completion()
            }
        }
    }
    
    func addLike(forIdea id: String, likes: Int, completion: @escaping ()->()) {
        ideasRef.child(id).child("likes").setValue(likes) { (error, reference) in
            if error == nil {
                completion()
            }
        }
    }
    
    //get comment for given comment id
    func getComments(forCommentIDs IDs: [String], completion: @escaping ([Comment])->()) {
        for id in IDs {
            self.myGroup.enter()
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
    
    //upload profile pic URL to firebase
    func uploadProfilePicURLToFirebase(_ userID: String, picURL: String, completion: @escaping ()->()) {
        ideaStorage.child(FIR.innovators).child(userID).child(FIR.profilePicURL).setValue(picURL) { (error, _) in
            if error == nil {
                completion()
            }
        }
    }
    
    func removeProfilePicURLFromFirebase(_ userID: String, completion: @escaping ()->()) {
    }
    
}
