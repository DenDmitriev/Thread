//
//  Animator.swift
//  VK
//
//  Created by Denis Dmitriev on 10.07.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit

class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    
    enum TransitionType {
        case presenting, dissmising
    }
    
    enum TransitionStyle {
        case rotate, scale
    }
    
    let type: TransitionType
    let style: TransitionStyle
    
    var frame: CGRect?
    
    init(type: TransitionType, style: TransitionStyle) {
        self.type = type
        self.style = style
    }
    
    init(type: TransitionType, style: TransitionStyle, frame: CGRect) {
        self.type = type
        self.style = style
        self.frame = frame
    }
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        guard
            let toView = transitionContext.view(forKey: .to),
            let fromView = transitionContext.view(forKey: .from)
            else { return }
        
        let frame = containerView.frame
        
        switch style {
        case .rotate:
            switch type {
            case .presenting:
                toView.layer.anchorPoint = CGPoint(x: 1, y: 0)
                toView.center = CGPoint(x: frame.width, y: 0)
                
                toView.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
                
                containerView.addSubview(toView)
                
                UIView.animate(
                    withDuration: transitionDuration(using: transitionContext),
                    animations: {
                        toView.transform = CGAffineTransform.identity
                },
                    completion: { finished in
                        transitionContext.completeTransition(finished)
                })
            case .dissmising:
                fromView.layer.anchorPoint = CGPoint(x: 1, y: 0)
                fromView.center = CGPoint(x: frame.width, y: 0)
                
                toView.frame = frame
                
                containerView.insertSubview(toView, belowSubview: fromView)
                
                UIView.animate(
                    withDuration: transitionDuration(using: transitionContext),
                    animations: {
                        fromView.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
                },
                    completion: { finished in
                        transitionContext.completeTransition(finished)
                })
            }
        case .scale:
            switch type {
            case .presenting:
                
                let fromCenter = CGPoint(x: self.frame?.midX ?? frame.midX, y: self.frame?.midY ?? frame.midY)
                toView.frame = frame
                let toCenter = toView.center
                toView.center = fromCenter
                
                toView.bounds = self.frame ?? frame
                
                containerView.addSubview(toView)


                UIView.animate(withDuration: transitionDuration(using: transitionContext), animations:  {
                    toView.bounds = frame
                    toView.center = toCenter
                }, completion: { finished in
                    transitionContext.completeTransition(finished)
                })
            case .dissmising:

                containerView.insertSubview(toView, belowSubview: fromView)
                
                UIView.animate(withDuration: transitionDuration(using: transitionContext), animations:  {
//                    fromView.frame = self.frame ?? frame
//                    fromView.bounds = self.frame ?? frame
                    fromView.alpha = 0
                }, completion: { finished in
                    transitionContext.completeTransition(finished)
                })
            }
        }
    }
}
