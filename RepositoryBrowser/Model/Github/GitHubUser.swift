//
//  GitHubUser.swift
//  RepositoryBrowser
//
//  Created by DDragutan on 3/31/20.
//  Copyright © 2020 DDragutan. All rights reserved.
//

import Foundation

struct GitHubUser: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case publicRepos = "public_repos"
        case avatarUrl = "avatar_url"
        case followers
        case following
        case bio
        case email
        case createdAt = "created_at"
    }
    
    var id:Int?
    var login:String?
    var publicRepos:Int?
    var avatarUrl:URL?
    var followers:Int?
    var following:Int?
    var bio:String?
    var email:String?
    var createdAt:Date?
}
