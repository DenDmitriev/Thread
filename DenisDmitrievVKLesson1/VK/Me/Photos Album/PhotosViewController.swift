//
//  PhotosViewController.swift
//  VK
//
//  Created by Denis Dmitriev on 08.07.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit
import AVFoundation
import RealmSwift
import Kingfisher

class PhotosViewController: UIViewController {
    
    lazy var realm = try! Realm()
    lazy var user: User = User()
    
    var image: UIImage!
    
    lazy var photos: [UIImage] = {
        let images = realm.objects(Photo.self).filter("user = %@", user)
        var photos: [UIImage] = []
        for image in images {
            guard let url = URL(string: image.url) else { return [] }
            let resource = ImageResource(downloadURL: url)
            KingfisherManager.shared.retrieveImage(with: resource) { (result) in
                let photo = try? result.get().image
                photos.append(photo!)
            }
        }
        return photos
    }()
    
    var uiHidden: Bool = false {
        didSet {
            navigationController?.navigationBar.isHidden = uiHidden
            tabBarController?.tabBar.isHidden = uiHidden
        }
    }
    
    lazy var animator = UIViewPropertyAnimator()
    
    lazy var assistImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    lazy var defaultCenter = CGPoint()
    lazy var defaultFrame = CGRect()
    
    lazy var move: CGFloat = 0
    
    var currentIndex = 0 {
        didSet {
            title = "\(currentIndex+1) из \(photos.count)"
        }
    }
    
    lazy var currentDirection: Direction = .next
    
    enum Control {
        static let separator: CGFloat = 10
        static let duration: TimeInterval = 0.5
    }
    
    enum Direction {
        case next, previous
        
        init(x: CGFloat) {
            self = x > 0 ? .previous : .next
        }
    }
    

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentIndex = photos.firstIndex(of: image) ?? 0
        title = "\(currentIndex+1) из \(photos.count)"
        imageView.image = photos[currentIndex]

        setupGestures()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        defaultCenter = imageView.center
        defaultFrame = imageView.frame
        assistImageView.frame = defaultFrame
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        uiHidden = false
    }
    
    @objc func tabView(sender: UITapGestureRecognizer) {
        print(#function)
        let imageFrame = AVMakeRect(aspectRatio: imageView.image?.size ?? imageView.frame.size, insideRect: imageView.bounds)
        if imageFrame.contains(sender.location(in: sender.view)) {
            Preview().previewImage(imageView: imageView, navigationController: navigationController, darkRoom: true)
        } else {
            uiHidden = !uiHidden
        }
    }
    
    func setupGestures() {
        
        let tabGesture = UITapGestureRecognizer(target: self, action: #selector(tabView))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        let gestures = [panGesture, tabGesture]
        gestures.forEach { gesture in
            imageView.addGestureRecognizer(gesture)
        }
    }
    
    func gestureAniamtionSetup(direction: Direction, nextIndex: Int) {
        
        currentDirection = direction
        
        switch direction {
        case .next:
            assistImageView.center.x += (view.frame.width + Control.separator)
            move = -(view.frame.width + Control.separator)
        case .previous:
            assistImageView.center.x -= (view.frame.width + Control.separator)
            move = +(view.frame.width + Control.separator)
        }
        
        assistImageView.image = photos[nextIndex]
        view.addSubview(assistImageView)
        
        animator = UIViewPropertyAnimator(duration: Control.duration, curve: .easeInOut) {
            self.imageView.center.x += self.move
            self.assistImageView.center = self.defaultCenter
        }
        
        animator.addCompletion { position in
            guard position == .end else { return }
            self.imageView.center = self.defaultCenter
            self.assistImageView.removeFromSuperview()
            self.assistImageView.center = self.defaultCenter
            self.currentIndex = nextIndex
            self.imageView.image = self.photos[nextIndex]
        }
        
    }
    
    
    @objc func panGesture(_ sender: UIPanGestureRecognizer) {
        
        
        let translation = sender.translation(in: sender.view)
        let direction = Direction(x: translation.x)
        
        guard ready(direction: direction, index: currentIndex) else {
            animator.stopAnimation(true)
            toDefault(direction: direction)
            return
        }
        
        let nextIndex = direction == .next ? currentIndex + 1 : currentIndex - 1
        
        switch sender.state {
        case .began:
            gestureAniamtionSetup(direction: direction, nextIndex: nextIndex)
            //animator.pauseAnimation()

        case .changed:
            
            if direction == currentDirection {
                animator.fractionComplete = abs(translation.x) / sender.view!.frame.width
            } else {
                animator.stopAnimation(true)
                
                self.assistImageView.removeFromSuperview()
                self.assistImageView.center = self.defaultCenter
                
                gestureAniamtionSetup(direction: direction, nextIndex: nextIndex)
            }
            
        case .ended:
            
            if  animator.fractionComplete > 0.5 {
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            } else {
                animator.stopAnimation(true)
                toDefault(direction: direction)
            }
            
        default:
            break
        }
    }
    
    func ready(direction: Direction, index: Int) -> Bool {
        switch direction {
        case .next:
            guard index != photos.count-1 else { return false }
        case .previous:
            guard index != 0 else { return false }
        }
        return true
    }
    
    func toDefault(direction: Direction) {
        UIView.animate(withDuration: 0.25, animations: {
            self.imageView.center = self.defaultCenter
            switch direction {
            case .next: self.assistImageView.center.x = self.view.frame.width*3/2 + Control.separator
            case .previous: self.assistImageView.center.x = -self.view.frame.width/2 - Control.separator
            }
            
        }) { _ in
            self.assistImageView.removeFromSuperview()
            self.assistImageView.center = self.defaultCenter
        }
    }
    
    
}
