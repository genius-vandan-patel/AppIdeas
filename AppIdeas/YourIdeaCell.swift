//
//  YourIdeaCell.swift
//  AppIdeas
//
//  Created by Vandan Patel on 9/23/17.
//  Copyright © 2017 Vandan Patel. All rights reserved.
//

import UIKit

class YourIdeaCell: UITableViewCell {

    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
