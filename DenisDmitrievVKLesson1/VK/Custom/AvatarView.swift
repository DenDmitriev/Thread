//
//  ViewAvatar.swift
//  1l_ДмитриевДенис
//
//  Created by Denis Dmitriev on 25.06.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit

@IBDesignable class  AvatarView: UIView {
    
    @IBInspectable var shadowColor: UIColor = .black {
        didSet {
            updateShadow()
        }
    }
   
    @IBInspectable var blurSize: CGFloat = 16.0 {
        didSet {
            updateShadow()
        }
    }

    @IBInspectable var shift: CGFloat = 4.0 {
        didSet {
            updateShadow()
        }
    }
    
    @IBInspectable var shadowAlphaPercent: CGFloat = 50 {
        didSet {
            updateShadow()
        }
    }
    
    @IBInspectable var image: UIImage? = nil {
        didSet {
            imageView.image = image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = imageView.frame.width/2
        shadowView.layer.cornerRadius = imageView.frame.width/2
    }
    
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    lazy var shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    func setup() {
        addSubview(shadowView)
        addSubview(imageView)
        
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
            shadowView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            shadowView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            shadowView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            shadowView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0)
        ])
    }
    

    
    
    func updateShadow() {
        shadowView.layer.shadowColor = shadowColor.cgColor
        shadowView.layer.shadowOpacity = Float(shadowAlphaPercent/100)
        shadowView.layer.shadowRadius = blurSize
        shadowView.layer.shadowOffset = CGSize(width: 0, height: shift)
    }
    
    
}

