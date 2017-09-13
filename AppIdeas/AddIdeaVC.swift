//
//  AddIdeaVC.swift
//  AppIdeas
//
//  Created by Vandan Patel on 8/21/17.
//  Copyright © 2017 Vandan Patel. All rights reserved.
//

import UIKit

class AddIdeaVC: UIViewController {

    @IBOutlet weak var ideaTextView: CustomizedUITextView!
    @IBOutlet weak var letsGoButton: CustomizedButton!
    @IBOutlet weak var charactersCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ideaTextView.delegate = self
    }
    
    @IBAction func letsGoTapped(_ sender: CustomizedButton) {
        let idea = Idea(_ideaID: nil, _ideaDescription: ideaTextView.text, _likes: 0, _comments: nil, _innovatorID: dataStorage.getCurrentUserID())
        DataStorage.sharedInstance.postIdea(idea: idea)
    }
}

extension AddIdeaVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newString = NSString(string: textView.text!).replacingCharacters(in: range, with: text)
        charactersCountLabel.text = newString.count >= 0 ? "\(150 - newString.count)" : "0"
        return newString.count <= 150
    }
}
