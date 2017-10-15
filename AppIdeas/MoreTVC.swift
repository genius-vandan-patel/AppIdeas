//
//  MoreTVC.swift
//  AppIdeas
//
//  Created by Vandan Patel on 9/23/17.
//  Copyright © 2017 Vandan Patel. All rights reserved.
//

import UIKit
import Firebase

class MoreTVC: UITableViewController {
    
    let logOutCellNuber = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == logOutCellNuber {
            didTapLogout()
        }
    }
    
    func didTapLogout() {
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] (_) in
            self?.showActivityIndicator()
            do {
                try Auth.auth().signOut()
                self?.markUserLoggedOut()
                self?.hideActivityIndicator()
                if let navigationController = self?.navigationController {
                    if let signInVC = navigationController.presentingViewController {
                        if let landingVC = signInVC.presentingViewController {
                            landingVC.dismiss(animated: true, completion: {})
                        }
                    }
                }
            } catch let signOutError {
                print("Error signing out : ", signOutError.localizedDescription)
            }
        }
        showAlertMessage(withTitle: "Logout", message: "Are you sure about logging out?", actions: [deleteAction, okAction])
    }
}
