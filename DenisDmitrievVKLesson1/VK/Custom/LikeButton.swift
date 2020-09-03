//
//  LikeButton.swift
//  VK
//
//  Created by Denis Dmitriev on 04.07.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit

@IBDesignable class LikeButton: UIControl {
    
    @IBInspectable var count: Int = 1 {
        didSet {
            update()
        }
    }
    
    @IBInspectable var status: Bool = false {
        didSet {
            update()
        }
    }
    
    @IBInspectable var enabledColor: UIColor = UIColor.red  {
        didSet {
            update()
        }
    }
    
    @IBInspectable var disabledColor: UIColor = UIColor.gray {
        didSet {
            update()
        }
    }
    
    @IBInspectable var enabledImage: UIImage = UIImage(systemName: "heart.fill")! {
        didSet {
            update()
        }
    }
    @IBInspectable var disabledImage: UIImage = UIImage(systemName: "heart")! {
        didSet {
            update()
        }
    }
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        actions()
        addSubview(button)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        actions()
        addSubview(button)
    }
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        button.imageView?.contentMode = .center
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    func layout() {
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            button.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            button.rightAnchor.constraint(equalTo: rightAnchor, constant: 0)
        ])
        button.titleLabel?.font = UIFont.systemFont(ofSize: frame.height/1.75)
    }
    
    func actions() {
        button.addTarget(self, action: #selector(tab(_:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(animation(_:)), for: .touchUpInside)
    }
    
    func setup() {
        button.titleLabel?.text = String(count)
        button.titleLabel?.textColor = status ? .red : .gray
        button.setTitle(String(count), for: .normal)
        button.setTitleColor(status ? enabledColor : disabledColor, for: .normal)
        button.tintColor = status ? .red : .gray
        button.imageView?.image = status ? enabledImage : disabledImage
        button.setImage(status ? enabledImage : disabledImage, for: .normal)
    }
    
    func update() {
        setup()
    }
    
    enum animationTime {
        static let long: TimeInterval = 1
        static let medium: TimeInterval = 0.5
        static let fast: TimeInterval = 0.25
    }
    
    
    @objc func tab(_ sender: UIButton) {
        print(#function)
        DispatchQueue.main.asyncAfter(deadline: .now() + animationTime.fast) {
            self.status = !self.status
            self.count += self.status ?  +1 : -1
        }
    }
    
    @objc func animation(_ sender: UIButton) {
        print(#function)
        UIView.animate(withDuration: animationTime.fast, animations: {
            sender.imageView?.transform = CGAffineTransform(scaleX: 0.01, y: 1)
        }) { _ in
            UIView.animate(withDuration: animationTime.fast) {
                sender.imageView?.transform = CGAffineTransform.identity
            }
        }
    }
}
