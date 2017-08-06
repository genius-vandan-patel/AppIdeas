//
//  CustomizedSegue.swift
//  AppIdeas
//
//  Created by Vandan Patel on 8/1/17.
//  Copyright © 2017 Vandan Patel. All rights reserved.
//

import UIKit

class CustomizedSegue: UIStoryboardSegue {

    override func perform() {
        animateIn()
    }
    
    func animateIn() {
        let toViewController = self.destination
        let fromViewController = self.source
        
        let containerView = fromViewController.view.superview
        let originalCenter = fromViewController.view.center
        
        toViewController.view.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        toViewController.view.center = originalCenter
        
        containerView?.addSubview(toViewController.view)
        
        UIView.animate(withDuration:  0.5, delay: 0, options: .curveEaseInOut, animations: {
            toViewController.view.transform = .identity
        }) { (success) in
            fromViewController.present(toViewController, animated: false, completion: nil)
        }
    }
}

class UnwindSegue: UIStoryboardSegue {
    
    override func perform() {
        animateOut()
    }
    
    func animateOut() {
        let toViewController = self.destination
        let fromViewController = self.source
        
        fromViewController.view.superview?.insertSubview(toViewController.view, at: 0)
        
        UIView.animate(withDuration:  0.5, delay: 0, options: .curveEaseInOut, animations: {
            fromViewController.view.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        }) { (success) in
            fromViewController.dismiss(animated: false, completion: nil)
        }
    }
}
