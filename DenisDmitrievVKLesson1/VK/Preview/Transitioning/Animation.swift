//
//  Animation.swift
//  VK
//
//  Created by Denis Dmitriev on 14.07.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit
import AVFoundation

class Animation: NSObject, UIViewControllerAnimatedTransitioning {
    
    enum PresentationType {
        case present, dissmis
        
        var isPresenting: Bool {
            return  self == .present
        }
        
        var duration: TimeInterval {
            return isPresenting ? 0.5 : 0.33
        }
    }
    
    init(type: PresentationType, startView: UIImageView? = nil, endView: UIImageView? = nil) {
        self.presentationType = type
        self.startView = startView
        self.endView = endView
    }
    
    let presentationType: PresentationType
    var startView: UIImageView?
    var endView: UIImageView?
        
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return presentationType.duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch presentationType {
        case .present:
            present(using: transitionContext)
        case .dissmis:
            dissmis(using: transitionContext)
        }
    }
    
    private func present(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        guard
            let toView = transitionContext.view(forKey: .to),
            let toViewController = transitionContext.viewController(forKey: .to),
            let startView = startView
            else {
                transitionContext.completeTransition(false)
                return
        }
        
        let originalFrame = startView.convert(startView.bounds, to: containerView)
        let finalFrame = transitionContext.finalFrame(for: toViewController)
        
        let imageSize = endView?.image?.size ?? CGSize(width: finalFrame.width, height: finalFrame.height)
        let imageBounds = AVMakeRect(aspectRatio: imageSize, insideRect: finalFrame)
        
        var xScale = originalFrame.width / finalFrame.width
        var yScale = originalFrame.height / finalFrame.height
        if originalFrame.height != finalFrame.height || originalFrame.width != finalFrame.width  {
            xScale = originalFrame.width / (finalFrame.width - (finalFrame.width - imageBounds.width))
            yScale = originalFrame.height / (finalFrame.height - (finalFrame.height - imageBounds.height))
        }
        
        toView.center = originalFrame.center
        toView.bounds = AVMakeRect(aspectRatio: imageSize, insideRect: toView.bounds)
        toView.transform = CGAffineTransform(scaleX: xScale, y: yScale)
        
        
        containerView.addSubview(toView)
        
        UIView.animateKeyframes(withDuration: presentationType.duration, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                toView.transform = CGAffineTransform.identity
                toView.center = finalFrame.center
            }
            UIView.addKeyframe(withRelativeStartTime: 1/2, relativeDuration: 1/2) {
                toView.bounds = finalFrame
            }
        }) { finished in
            transitionContext.completeTransition(finished)
        }
    }
    
    private func dissmis(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        guard
            let toView = transitionContext.view(forKey: .to),
            let fromView = transitionContext.view(forKey: .from),
            let startView = startView,
            let endView = endView
            else {
                transitionContext.completeTransition(false)
                return
        }
        
        let originalFrame = endView.frame
        let finalFrame = startView.convert(startView.bounds, to: containerView)
        
        let xScale = finalFrame.width / originalFrame.width
        let yScale = finalFrame.height / originalFrame.height
        
        containerView.addSubview(toView)
        containerView.bringSubviewToFront(fromView)
        
        UIView.animate(withDuration: presentationType.duration, animations: {
            fromView.transform = CGAffineTransform(scaleX: xScale, y: yScale)
            fromView.center = finalFrame.center
        }) { finished in
            transitionContext.completeTransition(finished)
        }
    }

}
