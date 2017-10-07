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
        view.addSubview(alertLabel)
        setupLayoutForLabel()
    }
    
    let alertLabel: UILabel = {
        let label = UILabel()
        label.text = "You have sucessfully created idea"
        label.textAlignment = .center
        label.alpha = 0.0
        return label
    }()
    
    func setupLayoutForLabel() {
        alertLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        alertLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        alertLabel.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
        alertLabel.widthAnchor.constraint(equalToConstant: 200.0).isActive = true
    }
    
    @IBAction func letsGoTapped(_ sender: CustomizedButton) {
        let idea = Idea(_ideaID: nil, _ideaDescription: ideaTextView.text, _likes: 0, _comments: nil, _innovatorID: dataStorage.getCurrentUserID())
        self.showActivityIndicator()
        DataStorage.sharedInstance.postIdea(idea: idea) { [weak self] in
            self?.hideActivityIndicator()
            self?.tabBarController?.selectedIndex = 0
        }

    }
}

extension AddIdeaVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newString = NSString(string: textView.text!).replacingCharacters(in: range, with: text)
        charactersCountLabel.text = newString.count <= 150 ? "\(150 - newString.count)" : "0"
        return newString.count <= 150
    }
}