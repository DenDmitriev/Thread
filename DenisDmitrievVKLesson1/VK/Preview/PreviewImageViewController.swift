//
//  PreviewImageViewController.swift
//  VK
//
//  Created by Denis Dmitriev on 11.07.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit
import AVFoundation

class PreviewImageViewController: UIViewController {
    
    var transitionController: Transition? {
        return transitioningDelegate as? Transition
    }
    
    var image: UIImage!
    
    var darkRoom: Bool = false {
        didSet {
            view.backgroundColor = darkRoom ? .black : .systemBackground
            cancelButton.isHidden = darkRoom
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        
        transitionController?.endView = imageView
        
        gestureSetup()
        
    }
    
    func gestureSetup() {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(cancel(_:)))
        swipeGesture.direction = .up
        let tabGesture = UITapGestureRecognizer(target: self, action: #selector(uiVisibale))
        let gestures = [swipeGesture, tabGesture]
        gestures.forEach { gesture in
            view.addGestureRecognizer(gesture)
        }
    }
    
    @objc func uiVisibale() {
        darkRoom = !darkRoom
    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        cancel()
    }

}
