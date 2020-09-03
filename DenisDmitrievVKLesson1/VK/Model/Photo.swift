//
//  Photo.swift
//  VK
//
//  Created by Denis Dmitriev on 03.08.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import Foundation
import RealmSwift

final class Photo: Object, Decodable {
    @objc dynamic var url: String = ""
    @objc dynamic var user: User?
    
    override class func primaryKey() -> String? {
        return "url"
    }
}
