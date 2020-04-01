//
//  GitHubUserList.swift
//  RepositoryBrowser
//
//  Created by DDragutan on 3/31/20.
//  Copyright © 2020 DDragutan. All rights reserved.
//

import Foundation

struct GitHubUserList: Codable {
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case users = "items"
    }
    
    var totalCount:Int?
    var incompleteResults:Bool?
    var users:[GitHubUser]?
}
