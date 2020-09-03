//
//  PostTableViewCell.swift
//  1l_ДмитриевДенис
//
//  Created by Denis Dmitriev on 01.07.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit
import Kingfisher

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: AvatarView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var datelabel: UILabel!
    
    @IBOutlet weak var stackViewUser: UIStackView!
    
    @IBOutlet weak var postTextLable: UILabel!
    
    @IBOutlet weak var likeControl: LikeButton!
    @IBOutlet weak var commentControl: LikeButton!
    @IBOutlet weak var repostControl: LikeButton!
    
    @IBOutlet weak var viewControl: LikeButton!
    @IBOutlet weak var stacViewControl: UIStackView!
    
    @IBOutlet weak var view: UIView!
    
    var height: CGFloat?
    
    func set(post: Post) {
        nameLabel.text = post.user.name
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        datelabel.text = dateFormatter.string(from: post.date)
        
        imageSet(path: post.user.avatar, imageView: avatarImageView.imageView)
        
        postTextLable.text = post.text ?? Lorem.tweet
        
        likeControl.count = post.score.likes ?? 0
        commentControl.count = post.score.comments ?? 0
        viewControl.count = post.score.views ?? 0
        repostControl.count = post.score.reposts ?? 0
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.separator.cgColor
        view.layer.borderWidth = 0.32
        height = frame.height
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func imageSet(path: String, imageView: UIImageView) {
        guard let url = URL(string: path) else { return }
        let resource = ImageResource(downloadURL: url)
        imageView.kf.setImage(with: resource)
    }

    
}
