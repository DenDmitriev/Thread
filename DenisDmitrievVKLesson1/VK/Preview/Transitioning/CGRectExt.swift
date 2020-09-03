//
//  CGRectExt.swift
//  VK
//
//  Created by Denis Dmitriev on 14.07.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}
