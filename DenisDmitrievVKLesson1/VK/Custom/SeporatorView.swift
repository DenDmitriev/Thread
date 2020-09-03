//
//  SeporatorView.swift
//  VK
//
//  Created by Denis Dmitriev on 13.07.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit

@IBDesignable class SeporatorView: UIView {
    
    let seporator: UIView = {
       let view = UIView()
        return view
    }()
    
    @IBInspectable var color: UIColor = .opaqueSeparator {
        didSet {
            update()
        }
    }
    
    @IBInspectable var height: CGFloat = 0.33 {
        didSet {
            update()
        }
    }
    
    @IBInspectable var align: Int = Align.top.rawValue {
        didSet {
            update()
        }
    }
    
    enum Align: Int {
        case top = 1
        case center = 2
        case bottom = 3
    }
    
    var alignConstraint: NSLayoutConstraint!

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
        constraints()
    }
    
    func setup() {
        addSubview(seporator)
        update()
    }
    
    func update() {
        seporator.layer.masksToBounds = true
        seporator.layer.cornerRadius = height/2
        seporator.backgroundColor = color
        switch align {
        case Align.top.rawValue:
            alignConstraint = seporator.topAnchor.constraint(equalTo: topAnchor, constant: 0)
        case Align.bottom.rawValue:
            alignConstraint = seporator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        case Align.center.rawValue:
            alignConstraint = seporator.centerYAnchor.constraint(equalTo: centerYAnchor)
        default:
            alignConstraint = seporator.topAnchor.constraint(equalTo: topAnchor, constant: 0)
        }
        seporator.layoutIfNeeded()
    }
    
    func constraints() {
        alignConstraint = seporator.topAnchor.constraint(equalTo: topAnchor, constant: 0)
        seporator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            seporator.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            seporator.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
            alignConstraint,
            seporator.heightAnchor.constraint(equalToConstant: height)
        ])
    }
}
