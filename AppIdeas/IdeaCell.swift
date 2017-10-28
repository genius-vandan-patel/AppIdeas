//
//  IdeaCell.swift
//  AppIdeas
//
//  Created by Vandan Patel on 8/17/17.
//  Copyright © 2017 Vandan Patel. All rights reserved.
//

import UIKit
import Spring
import SDWebImage

class IdeaCell: UITableViewCell {
    
    
    @IBOutlet weak var profilePicImageView: CustomizedUIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var ideaTextView: CustomizedUITextView!
    @IBOutlet weak var commentsImage: UIImageView!
    @IBOutlet weak var likeButton: SpringButton!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var ideaTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var favoriteImageView: SpringImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureIdeaCell(withIdea idea: Idea, andInnovator innovator: Innovator, likedIdea: Bool, favoriteIdea: Bool) {
        selectionStyle = .none
        profilePicImageView.image = #imageLiteral(resourceName: "Background")
        usernameLabel.text = innovator.fullName
        if let profilePicURL = innovator.profilePicURL {
            let url = URL(string: profilePicURL)
            profilePicImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Background"), options: [.progressiveDownload, .continueInBackground], completed: { (image, error, _, _) in
            })
        }
        ideaTextView.text = idea.ideaDescription
        ideaTextViewHeight.constant = ideaTextView.contentSize.height
        likedIdea ? likeButton.setImage(#imageLiteral(resourceName: "Like_On"), for: .normal) : likeButton.setImage(#imageLiteral(resourceName: "Like_Off"), for: .normal)
        favoriteImageView.image = favoriteIdea ? #imageLiteral(resourceName: "Favorite_Off") : #imageLiteral(resourceName: "Favorite_On")
        if let likes = idea.likes {
            likesLabel.text = String(likes)
        }
    }

}
