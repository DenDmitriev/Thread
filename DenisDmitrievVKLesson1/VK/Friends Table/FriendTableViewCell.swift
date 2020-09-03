//
//  FriendTableViewCell.swift
//  1l_ДмитриевДенис
//
//  Created by Denis Dmitriev on 21.06.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit
import Kingfisher

class FriendTableViewCell: UITableViewCell {
    
    var id: Int!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImage: AvatarView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(user: User) {
        id = user.id
        nameLabel.text = user.name + " " + user.lastname
        imageSet(path: user.avatar)
        avatarImage.layer.cornerRadius = avatarImage.frame.height/2
    }
    
    func imageSet(path: String) {
        guard let url = URL(string: path) else { return }
        let resource = ImageResource(downloadURL: url)
        avatarImage.imageView.kf.setImage(with: resource)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
