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
    
    func shakeAnimation(_ view: UIView) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: view.center.x - 10, y: view.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: view.center.x + 10, y: view.center.y))
        view.layer.add(animation, forKey: "position")
    }
    
    func hideView(_ view: UIView, withAnimation: Bool) {
        if withAnimation {
            UIView.animate(withDuration: 1.0, animations: {
                view.alpha = 0.0
            })
        } else {
            view.alpha = 0.0
        }
    }
    
    func showView(_ view: UIView, withAnimation: Bool) {
        if withAnimation {
            UIView.animate(withDuration: 1.5, delay: 0.0, options: .allowUserInteraction, animations: {
                view.alpha = 1.0
            }, completion: nil)
        } else {
            view.alpha = 1.0
        }
    }
    
    //animation for signUpVC
    func hideView(_ view: UIView, withAnimation: Bool, completion: @escaping () -> ()) {
        if withAnimation {
            UIView.animate(withDuration: 1.0, animations: {
                view.alpha = 0.0
            }, completion: { (_) in
                completion()
            })
        } else {
            view.alpha = 0.0
            completion()
        }
    }
}
