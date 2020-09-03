//
//  User.swift
//  1l_ДмитриевДенис
//
//  Created by Denis Dmitriev on 21.06.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit
import RealmSwift

final class User: Object, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var lastname: String = ""
    @objc dynamic var avatar: String = ""
    
    var photos = List<Photo>()
    
    //MARK: - Coding Keys
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "first_name"
        case lastname = "last_name"
        case avatar = "photo_100"
    }
    
    //MARK: - Decodable
    
    convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.lastname = try container.decode(String.self, forKey: .lastname)
        self.avatar = try container.decode(String.self, forKey: .avatar)
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
}

