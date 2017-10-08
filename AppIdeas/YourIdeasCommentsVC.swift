//
//  YourIdeasCommentsVC.swift
//  AppIdeas
//
//  Created by Vandan Patel on 9/24/17.
//  Copyright © 2017 Vandan Patel. All rights reserved.
//

import UIKit

class YourIdeasCommentsVC: UIViewController {
    
    var ideaID: String?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataStorage.getAllComments(forIdea: ideaID!) { [weak self] (success) in
            if success! {
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
}

extension YourIdeasCommentsVC: UITableViewDataSource {
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

extension YourIdeasCommentsVC: UITableViewDelegate {
    
}
