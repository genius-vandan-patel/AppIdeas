//
//  HomeVC.swift
//  AppIdeas
//
//  Created by Vandan Patel on 8/16/17.
//  Copyright © 2017 Vandan Patel. All rights reserved.
//

import UIKit
import Firebase
import Spring
import ViewAnimator
import SDWebImage

class HomeVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tappedCell: IdeaCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let userID = Auth.auth().currentUser?.uid
        self.showActivityIndicator()
        dataStorage.getAllIdeas { (success) in
            if success {
                dataStorage.createInnovatorDictionary(completion: { (success) in
                    if success {
                        dataStorage.getLikedIdeasByInnovator(for: userID!, completion: { (success) in
                            if success {
                                dataStorage.getFavoritedIdeasByInnovator(for: userID!, completion: { (success) in
                                    if success {
                                        DispatchQueue.main.async {
                                            self.hideActivityIndicator()
                                            self.tableView.reloadData()
                                            self.view.animateRandom()
                                        }
                                    }
                                })
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
    
    @objc func favoriteImagePressed(gesture: UITapGestureRecognizer) {
        let favoriteImage = gesture.view as! SpringImageView
        favoriteImage.animation = "pop"
        favoriteImage.animate()
        
        favoriteImage.isUserInteractionEnabled = false
        
        guard let cellNumber = gesture.view?.tag else { return }
        
        let isFavoritedIdea = InnovatorStorage.favoritedIdeas[IdeaStorage.ideas[cellNumber].ideaID!] != nil
        
        if !isFavoritedIdea {
            InnovatorStorage.favoritedIdeas[IdeaStorage.ideas[cellNumber].ideaID!] = ""
            dataStorage.addFavoritedToInnovator(withInnovatorID: (Auth.auth().currentUser?.uid)!, andIdeaID: IdeaStorage.ideas[cellNumber].ideaID!, completion: {
                DispatchQueue.main.async {
                    favoriteImage.isUserInteractionEnabled = true
                    self.tableView.reloadData()
                }
            })
        } else {
            InnovatorStorage.favoritedIdeas.removeValue(forKey: IdeaStorage.ideas[cellNumber].ideaID!)
            dataStorage.removeFavoritedFromInnovator(withID: IdeaStorage.ideas[cellNumber].ideaID!, completion: {
                DispatchQueue.main.async {
                    favoriteImage.isUserInteractionEnabled = true
                    self.tableView.reloadData()
                }
            })
            
        }
    }
    
    @objc func likeButtonPressed(_ sender: UIButton) {
        let button = sender as! SpringButton
        button.animation = "morph"
        button.animate()
        
        button.isEnabled = false
        let cellNumber = sender.tag
        
        let isLikedIdea = InnovatorStorage.likedIdeas[IdeaStorage.ideas[cellNumber].ideaID!] != nil
        
        if !isLikedIdea {
            IdeaStorage.ideas[cellNumber].likes = IdeaStorage.ideas[cellNumber].likes + 1
            InnovatorStorage.likedIdeas[IdeaStorage.ideas[cellNumber].ideaID!] = ""
            dataStorage.addLikedToInnovator(withInnovatorID: (Auth.auth().currentUser?.uid)!, andIdeaID: IdeaStorage.ideas[cellNumber].ideaID!) {
                dataStorage.addLike(forIdea: IdeaStorage.ideas[cellNumber].ideaID!, likes: IdeaStorage.ideas[cellNumber].likes, completion: {
                    DispatchQueue.main.async {
                        button.isEnabled = true
                        self.tableView.reloadData()
                    }
                })
            }
        } else {
            if IdeaStorage.ideas[cellNumber].likes > 0 {
                IdeaStorage.ideas[cellNumber].likes = IdeaStorage.ideas[cellNumber].likes - 1
                InnovatorStorage.likedIdeas.removeValue(forKey: IdeaStorage.ideas[cellNumber].ideaID!)
                dataStorage.dislikeIdea(withID: IdeaStorage.ideas[cellNumber].ideaID!, completion: {
                    dataStorage.addLike(forIdea: IdeaStorage.ideas[cellNumber].ideaID!, likes: IdeaStorage.ideas[cellNumber].likes, completion: {
                        DispatchQueue.main.async {
                            button.isEnabled = true
                            self.tableView.reloadData()
                        }
                    })
                })
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
    
    func setupFavoriteImageGesture(imageView: UIImageView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(favoriteImagePressed(gesture:)))
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
        
        cell.selectionStyle = .none
        cell.profilePicImageView.image = #imageLiteral(resourceName: "Background")
        cell.usernameLabel.text = InnovatorStorage.innovators[IdeaStorage.ideas[indexPath.row].innovatorID]?.fullName
        
        if let profilePicURL = InnovatorStorage.innovators[IdeaStorage.ideas[indexPath.row].innovatorID]?.profilePicURL {
            let url = URL(string: profilePicURL)
            cell.profilePicImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Background"), options: [.progressiveDownload, .continueInBackground], completed: { (image, error, _, _) in
            })
        }
        
        cell.ideaTextView.text = IdeaStorage.ideas[indexPath.row].ideaDescription
        cell.ideaTextViewHeight.constant = cell.ideaTextView.contentSize.height
        self.setupCommentsImageGesture(imageView: cell.commentsImage)
        cell.commentsImage.tag = indexPath.row
        self.setupFavoriteImageGesture(imageView: cell.favoriteImageView)
        cell.favoriteImageView.tag = indexPath.row
        cell.likeButton.tag = indexPath.row
        let isLikedIdea = InnovatorStorage.likedIdeas[IdeaStorage.ideas[indexPath.row].ideaID!] != nil
        isLikedIdea ? cell.likeButton.setImage(#imageLiteral(resourceName: "Like_On"), for: .normal) : cell.likeButton.setImage(#imageLiteral(resourceName: "Like_Off"), for: .normal)
        let isFavoritedIdea = InnovatorStorage.favoritedIdeas[IdeaStorage.ideas[indexPath.row].ideaID!] != nil
        cell.favoriteImageView.image = isFavoritedIdea ? #imageLiteral(resourceName: "Favorite_Off") : #imageLiteral(resourceName: "Favorite_On")
        cell.likeButton.addTarget(self, action: #selector(likeButtonPressed(_:)), for: .touchUpInside)
        
        if let likes = IdeaStorage.ideas[indexPath.row].likes {
            cell.likesLabel.text = "\(likes)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cell = Bundle.main.loadNibNamed("IdeaCell", owner: self, options: nil)?.first as? IdeaCell else {
            return 0.0
        }
        cell.ideaTextView.text = IdeaStorage.ideas[indexPath.row].ideaDescription
        cell.ideaTextViewHeight.constant = cell.ideaTextView.contentSize.height
        return cell.ideaTextViewHeight.constant + 140.0
    }
}
