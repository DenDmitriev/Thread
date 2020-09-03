//
//  PhotoCollectionViewCell.swift
//  1l_ДмитриевДенис
//
//  Created by Denis Dmitriev on 21.06.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var photoImage: UIImageView!
    
    
    func set(photo: Photo) {
        guard let url = URL(string: photo.url) else { return }
        let resource = ImageResource(downloadURL: url)
        photoImage.kf.setImage(with: resource)
    }
}
