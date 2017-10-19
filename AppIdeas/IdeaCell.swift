//
//  IdeaCell.swift
//  AppIdeas
//
//  Created by Vandan Patel on 8/17/17.
//  Copyright © 2017 Vandan Patel. All rights reserved.
//

import UIKit
import Spring

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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
