//
//  MoreTVC.swift
//  AppIdeas
//
//  Created by Vandan Patel on 9/23/17.
//  Copyright © 2017 Vandan Patel. All rights reserved.
//

import UIKit
import Firebase
import ViewAnimator

class MoreTVC: UITableViewController {
    
    let logOutCellNuber = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.animateRandom()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == logOutCellNuber {
            didTapLogout()
        }
    }
    
    func didTapLogout() {
        let deleteAction = UIAlertAction(title: "Logout", style: .destructive) { [weak self] (_) in
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
                    } else {
                        navigationController.tabBarController?.performSegue(withIdentifier: "toSignIn", sender: nil)
                    }
                }
            } catch let signOutError {
                print("Error signing out : ", signOutError.localizedDescription)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (_) in }
        
        showAlertMessage(withTitle: "Logout", message: "Are you sure about logging out?", actions: [deleteAction, cancelAction])
    }
}
