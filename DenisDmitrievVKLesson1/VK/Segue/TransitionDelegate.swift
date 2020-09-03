//
//  TransitionDelegate.swift
//  VK
//
//  Created by Denis Dmitriev on 10.07.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit

class TransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    var imageFrame: CGRect = CGRect()
    
    init(frame: CGRect) {
        self.imageFrame = frame
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Animator(type: .presenting, style: .scale, frame: imageFrame)
    }
    
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Animator(type: .dissmising, style: .scale, frame: imageFrame)
    }
    
    /*
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
    }
    */
    
}
