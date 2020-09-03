//
//  Groups.swift
//  1l_ДмитриевДенис
//
//  Created by Denis Dmitriev on 21.06.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit
import RealmSwift

final class Group: Object, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var avatar: String = ""
    
    //MARK: - Coding Keys
    
    enum CodingKeys: String, CodingKey {
        case id
        case title = "name"
        case avatar = "photo_100"
    }
    
    //MARK: - Decodable
    
    convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.avatar = try container.decode(String.self, forKey: .avatar)
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}


