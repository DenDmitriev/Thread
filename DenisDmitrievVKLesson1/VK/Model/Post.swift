//
//  Post.swift
//  1l_ДмитриевДенис
//
//  Created by Denis Dmitriev on 01.07.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit

final class Post {
    let type : PostType
    let user: User
    let date: Date
    var text: String?
    var image: String = "https://picsum.photos/\(String(Int.random(in: 300...400)))"
    
    var score: SocialScore
    
    init(user: User) {
        self.type = Int.random(in: 0...1) == 0 ? .post : .photo
        self.user = user
        self.date = Date()
        self.score = SocialScore(likes: 0, comments: 0, reposts: 0, views: 0)
    }
}

struct SocialScore {
    let likes: Int?
    let comments: Int?
    let reposts: Int?
    let views: Int?
}

enum PostType {
    case post
    case photo
}
