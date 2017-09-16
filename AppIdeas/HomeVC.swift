//
//  HomeVC.swift
//  AppIdeas
//
//  Created by Vandan Patel on 8/16/17.
//  Copyright © 2017 Vandan Patel. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tappedCell: IdeaCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataStorage.getAllIdeas { (success) in
            if success {
                dataStorage.createInnovatorDicationary(completion: { (success) in
                    if success {
                        DispatchQueue.main.async { self.tableView.reloadData() }
                    }
                })
            }
        }
    }
    
    @objc func commentsImagePressed(gesture: UITapGestureRecognizer) {
        guard let cellNumber = gesture.view?.tag else { return }
        performSegue(withIdentifier: SEGUES.HomeToComments, sender: IdeaStorage.ideas[cellNumber].ideaID)
    }
    
    @objc func likeButtonPressed(_ sender: UIButton) {
        let cellNumber = sender.tag
        let incrementedLikes = IdeaStorage.ideas[cellNumber].likes + 1
        dataStorage.addLikeToIdea(withID: IdeaStorage.ideas[cellNumber].ideaID!, andLikes: incrementedLikes) {
            DispatchQueue.main.async {
                //update UI
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let ID = sender as? String else { return }
        if segue.identifier == SEGUES.HomeToComments {
            if let destinationVC = segue.destination as? CommentsVC {
                destinationVC.ideaID = ID
            }
        }
    }
    
    func setupCommentsImageGesture(imageView: UIImageView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(commentsImagePressed(gesture:)))
        tapGesture.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(tapGesture)
    }
}

extension HomeVC: UITableViewDelegate {
    
}

extension HomeVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IdeaStorage.ideas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = Bundle.main.loadNibNamed("IdeaCell", owner: self, options: nil)?.first as? IdeaCell else {
            print("Error Creating Cell For Idea")
            return UITableViewCell()
        }
        cell.profilePicImageView.image = #imageLiteral(resourceName: "Background")
        cell.usernameLabel.text = InnovatorStorage.innovators[IdeaStorage.ideas[indexPath.row].innovatorID]?.fullName
        cell.ideaTextView.text = IdeaStorage.ideas[indexPath.row].ideaDescription
        if let likes = IdeaStorage.ideas[indexPath.row].likes {
           cell.likesLabel.text = "\(likes)"
        }
        self.setupCommentsImageGesture(imageView: cell.commentsImage)
        cell.commentsImage.tag = indexPath.row
        cell.likeButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(likeButtonPressed(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
}
