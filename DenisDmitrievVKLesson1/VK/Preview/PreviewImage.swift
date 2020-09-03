//
//  PreviewImage.swift
//  VK
//
//  Created by Denis Dmitriev on 13.07.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit

class Preview {
    
    let transitionController = Transition()
    
    func previewImage(imageView: UIImageView, navigationController: UINavigationController?, darkRoom: Bool) {
        guard imageView.image != nil else { return }
        let previewViewController = PreviewImageViewController(nibName: "PreviewImageViewController", bundle: nil)
        previewViewController.modalPresentationStyle = .fullScreen
        previewViewController.image = imageView.image
        previewViewController.darkRoom = darkRoom
        previewViewController.transitioningDelegate = transitionController
        transitionController.startView = imageView
        transitionController.endView = previewViewController.imageView
        
        navigationController?.present(previewViewController, animated: true, completion: nil)
    }
}




