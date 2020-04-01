//
//  Repository.swift
//  RepositoryBrowser
//
//  Created by DDragutan on 3/31/20.
//  Copyright © 2020 DDragutan. All rights reserved.
//

import Foundation

/*
The purpose of these protocol is to abstract details of particular Codable objects (GitHub, BitBucket ...)
and expose universal interface that are used in the app to show repository info
*/

protocol RepositoryObject {
    var name:String? {get}
    var starsCount:Int? {get}
    var forksCount:Int? {get}
}

struct Repository: RepositoryObject {
    var name:String?
    var starsCount:Int?
    var forksCount:Int?
    
    private init() {}
    
    private init(repo: GitHubRepository) {
        self.name = repo.name
        self.starsCount = repo.starsCount
        self.forksCount = repo.forksCount
    }

    static func `for`<T:Codable>(_ object:T) -> Repository {
        switch object {
        case let repo as GitHubRepository: return Repository(repo: repo)
        default: return Repository()
        }
    }
}
