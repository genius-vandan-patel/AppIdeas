//
//  YourFavoritesVC.swift
//  AppIdeas
//
//  Created by Vandan Patel on 10/9/17.
//  Copyright © 2017 Vandan Patel. All rights reserved.
//

import UIKit

class YourFavoritesVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var favoriteIdeaIDs: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoriteIdeaIDs = Array(InnovatorStorage.favoritedIdeas.keys)
        self.showActivityIndicator()
        dataStorage.getFavoriteIdeas(forIdeaIDs: favoriteIdeaIDs!) { [weak self] (success) in
            DispatchQueue.main.async {
                if success {
                    self?.hideActivityIndicator()
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IdeaStorage.yourFavoriteIdeas.removeAll()
        self.tableView.reloadData()
    }
}

extension YourFavoritesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IdeaStorage.yourFavoriteIdeas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = Bundle.main.loadNibNamed("FavotireIdeaCell", owner: self, options: nil)?.first as? FavotireIdeaCell else {
            return UITableViewCell()
        }
        
        if IdeaStorage.yourFavoriteIdeas.count != 0 {
            cell.ideaDesc.text = IdeaStorage.yourFavoriteIdeas[indexPath.row].ideaDescription
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
