//
//  GitHubRepository.swift
//  RepositoryBrowser
//
//  Created by DDragutan on 3/31/20.
//  Copyright © 2020 DDragutan. All rights reserved.
//

import Foundation

struct GitHubRepository: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case starsCount = "stargazers_count"
        case forksCount = "forks_count"
        case htmlUrl = "html_url"
    }

    var name:String
    var starsCount:Int?
    var forksCount:Int?
    var htmlUrl:URL?
}
