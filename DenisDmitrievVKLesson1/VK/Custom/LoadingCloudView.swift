//
//  LoadingCloudView.swift
//  VK
//
//  Created by Denis Dmitriev on 08.07.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit

@IBDesignable class LoadingCloudView: UIView {

    let cloudShape = CAShapeLayer()
    let strokeColor = UIColor(displayP3Red: 70/255, green: 128/255, blue: 194/255, alpha: 1)
    let fillColor = UIColor.gray.withAlphaComponent(0.25)
    let background = UIView()
    
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
    }
    
    func setup() {
        
        cloudShape.path = shapeDraw()
        cloudShape.fillColor = fillColor.cgColor
        cloudShape.lineWidth = 3
        cloudShape.lineCap = .round
        cloudShape.strokeColor = strokeColor.cgColor
        cloudShape.strokeStart = 0
        cloudShape.strokeEnd = 0
        layer.addSublayer(cloudShape)
        
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
        
        let shapeView = UIView()
        
        addSubview(shapeView)
        shapeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            shapeView.widthAnchor.constraint(equalToConstant: 50),
            shapeView.heightAnchor.constraint(equalToConstant: 50),
            shapeView.centerXAnchor.constraint(equalTo: centerXAnchor),
            shapeView.topAnchor.constraint(equalTo: topAnchor, constant: 0)
        ])
        
        shapeView.layer.addSublayer(cloudShape)
        
        
        
    }
    
    
    
    
    
    func shapeDraw() -> CGPath {
        
        let cloudPath = UIBezierPath()
        
        cloudPath.move(to: CGPoint(x: 7.53, y: 25.5))
        cloudPath.addLine(to: CGPoint(x: 40.74, y: 25.5))
        cloudPath.addCurve(to: CGPoint(x: 39.44, y: 11.5), controlPoint1: CGPoint(x: 50.23, y: 25.5), controlPoint2: CGPoint(x: 49.67, y: 11.61))
        cloudPath.addCurve(to: CGPoint(x: 22.27, y: 7.64), controlPoint1: CGPoint(x: 42.21, y: 2.34), controlPoint2: CGPoint(x: 25.38, y: -1.3))
        cloudPath.addCurve(to: CGPoint(x: 10.13, y: 13.37), controlPoint1: CGPoint(x: 17.19, y: 4.44), controlPoint2: CGPoint(x: 10.86, y: 8.35))
        cloudPath.addCurve(to: CGPoint(x: 7.53, y: 25.5), controlPoint1: CGPoint(x: 0.53, y: 12.87), controlPoint2: CGPoint(x: -0.1, y: 25.11))



        cloudPath.close()
        
        return cloudPath.cgPath
    }
    
    func beginLoad() {
        let pathStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        pathStartAnimation.fromValue = 0
        pathStartAnimation.toValue = 1
        
        let pathEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathEndAnimation.fromValue = 0
        pathEndAnimation.toValue = 1.2
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 2
        animationGroup.repeatCount = .infinity
        animationGroup.animations = [pathStartAnimation, pathEndAnimation]
        
        cloudShape.add(animationGroup, forKey: nil)
    }
    
    func endLoad() {
        cloudShape.removeAllAnimations()
    }

}
