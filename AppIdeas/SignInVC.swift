//
//  SignInVC.swift
//  AppIdeas
//
//  Created by Vandan Patel on 8/1/17.
//  Copyright © 2017 Vandan Patel. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {
    
    
    @IBOutlet weak var cancelButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        cancelButton.setImage(#imageLiteral(resourceName: "Cancel"), for: .normal)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
