//
//  CommentsVC.swift
//  AppIdeas
//
//  Created by Vandan Patel on 9/3/17.
//  Copyright © 2017 Vandan Patel. All rights reserved.
//

import UIKit
import Firebase

class CommentsVC: UIViewController {
    
    @IBOutlet weak var commentTextView: CustomizedUITextView!
    var ideaID: String?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Comments"
        guard let ideaID = ideaID else {
            print("Can not get id of idea")
            return }
        showActivityIndicator()
        commentTextView.text = "Add Comment"
        commentTextView.textColor = UIColor.lightGray
        commentTextView.delegate = self
        DataStorage.sharedInstance.getAllComments(forIdea: ideaID) { [weak self] (success) in
            if success! {
                DispatchQueue.main.async {
                    self?.hideActivityIndicator()
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        CommentsStorage.comments.removeAll()
        tableView.reloadData()
    }
    
    @IBAction func postButtonTapped(_ sender: CustomizedButton) {
        let comment = Comment(_commentDescription: commentTextView.text, _innovatorName: InnovatorStorage.innovators[(Auth.auth().currentUser?.uid)!]?.fullName)
        guard let id = ideaID else { return }
        DataStorage.sharedInstance.postComment(comment: comment, ideaID: id)
    }
}

extension CommentsVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CommentsStorage.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = Bundle.main.loadNibNamed("CommentsCell", owner: self, options: nil)?.first as? CommentsCell else {
            print("Error Creating Cell For Idea")
            return UITableViewCell()
        }
        cell.nameLabel.text = CommentsStorage.comments[indexPath.row].innovatorName
        cell.commentsTextView.text = CommentsStorage.comments[indexPath.row].commentDescription
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}

extension CommentsVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
}







