//
//  FilterControl.swift
//  1l_ДмитриевДенис
//
//  Created by Denis Dmitriev on 27.06.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit

protocol FilterControlDelegate: class {
    func gestutePan(char: String)
}

class FilterControl: UIControl {
    
    weak var delegate: FilterControlDelegate?
    
    var alphabet = "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ".map { String($0) }

    private var buttons: [UIButton] = []
    private var stackView: UIStackView!
    private var gestureView: UIView!
    
    var char: String? = nil {
        didSet {
            //self.sendActions(for: .touchUpInside)
            self.sendActions(for: .touchDown)
            
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
        stackView.frame = bounds
        gestureView.frame = bounds
    }
    
    private func setup() {
        
        for view in subviews {
            view.removeFromSuperview()
        }
        
        for char in alphabet {
            let button = UIButton(type: .system)
            button.setTitle(char, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 8)
            buttons.append(button)
        }
        
        stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        
        gestureView = UIView()
        gestureView.isUserInteractionEnabled = true
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(charGesture))
        gestureView.addGestureRecognizer(gesture)
        
        addSubview(stackView)
        addSubview(gestureView)
    }
    
    @objc func charGesture(_ sender: UIPanGestureRecognizer) {
        let location = sender.location(in: gestureView)
        for button in buttons {
            let frame = button.frame
            if frame.contains(location) {
                char = button.titleLabel?.text
                delegate?.gestutePan(char: char!)
                break
            }
        }
    }
    
    @objc func selectChar(_ sender: UIButton) {
        let index = buttons.firstIndex(of: sender)
        let char = alphabet[index!]
        self.char = char
    }
    
    
    func update() {
        buttons = []
        setup()
    }

}
