//
//  Response.swift
//  VK
//
//  Created by Denis Dmitriev on 02.08.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import Foundation

struct Response<T: Decodable>: Decodable {
    var count: Int
    var items: [T]
    
    enum CodingKeys: String, CodingKey {
        case response
        case items
        case count
    }
    
    init(from decoder: Decoder) throws {
        let topContainer = try decoder.container(keyedBy: CodingKeys.self)
        let container = try topContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .response)
        self.count = try container.decode(Int.self, forKey: .count)
        self.items = try container.decode([T].self, forKey: .items)
    }
}

struct AlbomSize: Decodable {
    var sizes: [Photo]
}
