//
//  GroupTableViewCell.swift
//  1l_ДмитриевДенис
//
//  Created by Denis Dmitriev on 21.06.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit
import Kingfisher

class GroupTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var avatarView: AvatarView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(group: Group) {
        titleLabel.text = group.title
        imageSet(path: group.avatar)
    }
    
    func imageSet(path: String) {
        guard let url = URL(string: path) else { return }
        let resource = ImageResource(downloadURL: url)
        avatarView.imageView.kf.setImage(with: resource)
    }

}
