//
//  IdeaCell.swift
//  AppIdeas
//
//  Created by Vandan Patel on 8/17/17.
//  Copyright © 2017 Vandan Patel. All rights reserved.
//

import UIKit

class IdeaCell: UITableViewCell {
    
    
    @IBOutlet weak var profilePicImageView: CustomizedUIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var ideaTextView: CustomizedUITextView!
    @IBOutlet weak var commentsImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var ideaTextViewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
