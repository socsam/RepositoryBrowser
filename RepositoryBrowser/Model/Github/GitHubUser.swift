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
        case login
        case avatarUrl = "avatar_url"
        case followers
        case following
        case bio
        case email
        case createdAt = "created_at"
        case publicRepos = "public_repos"
        case reposUrl = "repos_url"
    }
    
    var login:String
    var avatarUrl:URL?
    var followers:Int?
    var following:Int?
    var bio:String?
    var email:String?
    var createdAt:Date?
    var publicRepos:Int?
    var reposUrl:URL?
}
