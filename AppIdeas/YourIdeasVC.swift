//
//  YourIdeasVC.swift
//  AppIdeas
//
//  Created by Vandan Patel on 9/23/17.
//  Copyright © 2017 Vandan Patel. All rights reserved.
//

import UIKit
import ViewAnimator

class YourIdeasVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        dataStorage.getIdeasForCurrentUser { [weak self] (success) in
            if success {
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.view.animateRandom()
                }
            }
        }
    }
    
    @objc func commentImagePressed(_ gesture: UITapGestureRecognizer) {
        guard let cellNumber = gesture.view?.tag else { return }
        performSegue(withIdentifier: SEGUES.YourIdeasToComments, sender: IdeaStorage.yourIdeasIDs[cellNumber])
    }
    
    func setupCommentsImageGesture(forImageView imageView: UIImageView) {
        let tapGestureForComments = UITapGestureRecognizer(target: self, action: #selector(commentImagePressed(_:)))
        tapGestureForComments.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(tapGestureForComments)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let ID = sender as? String else { return }
        if segue.identifier == SEGUES.YourIdeasToComments {
            if let destinationVC = segue.destination as? YourIdeasCommentsVC {
                destinationVC.ideaID = ID
            }
        }
    }
}

extension YourIdeasVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IdeaStorage.yourIdeas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = Bundle.main.loadNibNamed("YourIdeaCell", owner: self, options: nil)?.first as? YourIdeaCell else {
            print("Error Creating Cell for Your Idea!")
            return UITableViewCell()
        }
        cell.descriptionTextView.text = IdeaStorage.yourIdeas[indexPath.row].ideaDescription
        if let likes = IdeaStorage.yourIdeas[indexPath.row].likes {
            cell.likesLabel.text = "\(likes)"
        }
        cell.commentsImageView.tag = indexPath.row
        setupCommentsImageGesture(forImageView: cell.commentsImageView)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
}

extension YourIdeasVC: UITableViewDelegate {
}
