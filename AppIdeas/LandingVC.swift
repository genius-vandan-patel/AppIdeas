//
//  ViewController.swift
//  AppIdeas
//
//  Created by Vandan Patel on 7/30/17.
//  Copyright © 2017 Vandan Patel. All rights reserved.
//

import UIKit

class LandingVC: UIViewController {
    
    @IBOutlet weak var signIn: CustomizedButton!
    @IBOutlet weak var signUp: CustomizedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appIdeasAnimation.slideInAnimation(signIn, delay: 0.3, duration: 1.0)
        appIdeasAnimation.slideInAnimation(signUp, delay: 0.0, duration: 1.5)
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {}
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        let segue = UnwindSegue(identifier: unwindSegue.identifier, source: unwindSegue.source, destination: unwindSegue.destination)
        segue.perform()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

