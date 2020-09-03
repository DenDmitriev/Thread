//
//  LoadingAnimationView.swift
//  VK
//
//  Created by Denis Dmitriev on 05.07.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit

@IBDesignable class LoadingAnimationView: UIView {

    lazy var points: [UIView] = []
    var stackView: UIStackView!
    let background = UIView()
    let stackBackground = UIView()
    
    var loading: Bool = true
    
    let duration: TimeInterval = 1
    
    @IBInspectable var size: CGFloat = 5
    
    var pulsColor: UIColor = UIColor(displayP3Red: 70/255, green: 128/255, blue: 194/255, alpha: 1)

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
    
    var alignment: Align = .top
    
    enum Align {
        case top
        case center
    }
    
    
    private func setup() {
        
        layer.masksToBounds = true
        
        background.backgroundColor = .white
        background.alpha = 0.8
        addSubview(background)
        background.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            background.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            background.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            background.rightAnchor.constraint(equalTo: rightAnchor, constant: 0)
        ])
        
        
        addSubview(stackBackground)
        
        for _ in 1...3 {
            let point = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
            point.layer.cornerRadius = size/2
            point.layer.masksToBounds = true
            point.backgroundColor = .lightGray
            point.alpha = 0.5
            points.append(point)
        }
        
        stackView = UIStackView(arrangedSubviews: points)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = size
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
    }
    
    func constraints() {
        switch alignment {
        case .top:
            NSLayoutConstraint.activate([
                stackView.widthAnchor.constraint(equalToConstant: size*5),
                stackView.heightAnchor.constraint(equalToConstant: size),
                stackView.topAnchor.constraint(equalTo: topAnchor, constant: 25),
                stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
        case .center:
            NSLayoutConstraint.activate([
                stackView.widthAnchor.constraint(equalToConstant: size*5),
                stackView.heightAnchor.constraint(equalToConstant: size),
                stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
                stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }
    }
    
    func beginLoad() {
        print(#function)
        let relativeDuration: Double = 1/3
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: [.repeat], animations: {
            self.animationParemters(view: self.points[2], active: true)
    
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: relativeDuration) {
                self.animationParemters(view: self.points[2], active: false)
                self.animationParemters(view: self.points[0], active: true)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: relativeDuration) {
                self.animationParemters(view: self.points[0], active: false)
                self.animationParemters(view: self.points[1], active: true)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: relativeDuration) {
                self.animationParemters(view: self.points[1], active: false)
                self.animationParemters(view: self.points[2], active: true)
            }
        })
    }
    
    func endLoad() {
        print(#function)
        loading = false
        for point in self.points {
            point.layer.removeAllAnimations()
        }
    }
    
    func animationParemters(view: UIView, active: Bool) {
        if active {
            view.backgroundColor = self.pulsColor
            view.transform = CGAffineTransform(scaleX: 1.17, y: 1.17)
            view.alpha = 1
        }
        else {
            view.backgroundColor = .lightGray
            view.transform = CGAffineTransform.identity
            view.alpha = 0.5
        }
    }
}


