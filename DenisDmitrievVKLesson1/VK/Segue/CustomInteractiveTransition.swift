//
//  CustomInteractiveTransition.swift
//  VK
//
//  Created by Denis Dmitriev on 11.07.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit

class CustomInteractiveTransition: UIPercentDrivenInteractiveTransition {
    
    var viewController: UIViewController? {
        didSet {
            let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(dissmisGesture(sender:)))
            edgePan.edges = .left
            viewController?.view.addGestureRecognizer(edgePan)
        }
    }
    
    var hasStarted: Bool = false
    var shouldFinish: Bool = false
    
    @objc func dissmisGesture(sender: UIScreenEdgePanGestureRecognizer) {
        switch sender.state {
        case .began:
            self.hasStarted = true
            self.viewController?.navigationController?.popViewController(animated: true)
        case .changed:
            guard let senderView = sender.view else { return }
            let translate = sender.translation(in: senderView)
            let percent = abs(translate.x) * 8 / senderView.bounds.width
            self.shouldFinish = percent > 0.33
            self.update(percent)
        case .ended:
            self.hasStarted = false
            self.shouldFinish ? self.finish() : self.cancel()
        case .cancelled:
            self.hasStarted = false
            self.cancel()
        default:
            return
        }
        
    }

}
