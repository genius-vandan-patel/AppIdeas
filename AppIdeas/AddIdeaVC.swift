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
    @IBOutlet weak var ideaTextViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ideaTextView.delegate = self
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        ideaTextView.setContentOffset(.zero, animated: true)
    }
    
    @IBAction func letsGoTapped(_ sender: CustomizedButton) {
        if !ideaTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            let idea = Idea(_ideaID: nil, _ideaDescription: ideaTextView.text, _likes: 0, _comments: nil, _innovatorID: dataStorage.getCurrentUserID())
            self.showActivityIndicator()
            DataStorage.sharedInstance.postIdea(idea: idea) { [weak self] in
                self?.hideActivityIndicator()
                self?.tabBarController?.selectedIndex = 0
            }
        } else {
            showAlertMessage(withTitle: "Oops", message: "Please Share Your Thoughts With Us. We can't read your mind!", actions: [okAction])
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchView = touches.first?.view else { return }
        if touchView != ideaTextView {
            view.endEditing(true)
        }
    }
}

extension AddIdeaVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        let newString = NSString(string: textView.text!).replacingCharacters(in: range, with: text)
        charactersCountLabel.text = newString.count <= 150 ? "\(150 - newString.count)" : "0"
        return newString.count <= 150
    }
    
    func textViewDidChange(_ textView: UITextView) {
        ideaTextViewHeightConstraint.constant = textView.contentSize.height
    }
}
