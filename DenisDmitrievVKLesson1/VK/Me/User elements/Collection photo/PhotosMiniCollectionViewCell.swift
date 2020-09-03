//
//  PhotosMiniCollectionViewCell.swift
//  VK
//
//  Created by Denis Dmitriev on 13.07.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit
import Kingfisher

class PhotosMiniCollectionViewCell: UICollectionViewCell {
    

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
    }
    
    func set(photo: Photo) {
        guard let url = URL(string: photo.url) else { return }
        let resource = ImageResource(downloadURL: url)
        imageView.kf.setImage(with: resource)
    }

}
