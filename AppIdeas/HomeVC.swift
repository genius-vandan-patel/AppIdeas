//
//  HomeVC.swift
//  AppIdeas
//
//  Created by Vandan Patel on 8/16/17.
//  Copyright © 2017 Vandan Patel. All rights reserved.
//

import UIKit
import Firebase

class HomeVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tappedCell: IdeaCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userID = Auth.auth().currentUser?.uid
        self.showActivityIndicator()
        dataStorage.getAllIdeas { (success) in
            if success {
                dataStorage.createInnovatorDictionary(completion: { (success) in
                    if success {
                        dataStorage.getLikedIdeasByInnovator(for: userID!, completion: { (success) in
                            if success {
                                DispatchQueue.main.async {
                                    self.hideActivityIndicator()
                                    self.tableView.reloadData()
                                }
                            }
                        })
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
        let idea = IdeaStorage.ideas[cellNumber]
        var likes = idea.likes
        if sender.currentImage == #imageLiteral(resourceName: "Like_Off") {
            likes = likes! + 1
            dataStorage.addLikedToInnovator(withInnovatorID: (Auth.auth().currentUser?.uid)!, andIdeaID: IdeaStorage.ideas[cellNumber].ideaID!) {
                dataStorage.addLike(forIdea: IdeaStorage.ideas[cellNumber].ideaID!, likes: likes!, completion: {
                })
            }
        } else if sender.currentImage == #imageLiteral(resourceName: "Like_On") {
            likes = likes! - 1
            dataStorage.dislikeIdea(withID: IdeaStorage.ideas[cellNumber].ideaID!, completion: {
                dataStorage.addLike(forIdea: IdeaStorage.ideas[cellNumber].ideaID!, likes: likes!, completion: {
                })
            })
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

extension HomeVC: UITableViewDelegate {}

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
        self.setupCommentsImageGesture(imageView: cell.commentsImage)
        cell.commentsImage.tag = indexPath.row
        cell.likeButton.tag = indexPath.row
        let isLikedIdea = InnovatorStorage.likedIdeas[IdeaStorage.ideas[indexPath.row].ideaID!] != nil
        isLikedIdea ? cell.likeButton.setImage(#imageLiteral(resourceName: "Like_On"), for: .normal) : cell.likeButton.setImage(#imageLiteral(resourceName: "Like_Off"), for: .normal)
        cell.likeButton.addTarget(self, action: #selector(likeButtonPressed(_:)), for: .touchUpInside)
        if let likes = IdeaStorage.ideas[indexPath.row].likes {
            cell.likesLabel.text = "\(likes)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
}
