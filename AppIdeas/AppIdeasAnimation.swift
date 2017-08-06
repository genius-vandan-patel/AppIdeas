//
//  AppIdeasAnimation.swift
//  AppIdeas
//
//  Created by Vandan Patel on 7/30/17.
//  Copyright © 2017 Vandan Patel. All rights reserved.
//

import UIKit

let appIdeasAnimation = AppIdeasAnimation.sharedInstance

class AppIdeasAnimation {
    
    static let sharedInstance = AppIdeasAnimation()
    
    func slideInAnimation(_ view: UIView, delay: Double, duration: Double) {
        view.transform = CGAffineTransform(translationX: -(view.superview?.frame.width)!, y: 0)
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .allowUserInteraction, animations: {
            view.transform = .identity
        }) { (success) in }
    }
    
    func fadeInAnimation(_ view: UIView, delay: Double, duration: Double) {
        view.alpha = 0.0
        UIView.animate(withDuration: duration, delay: delay, options: .allowUserInteraction, animations: { 
            view.alpha = 1.0
        }, completion: nil)
    }
    
    func scaleInAnimation(_ view: UIView, delay: Double, duration: Double) {
        view.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        UIView.animate(withDuration: duration, delay: delay, options: .allowUserInteraction, animations: { 
            view.transform = .identity
        }, completion: nil)
    }
}
