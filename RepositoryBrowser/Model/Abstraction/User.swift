//
//  User.swift
//  RepositoryBrowser
//
//  Created by DDragutan on 3/31/20.
//  Copyright © 2020 DDragutan. All rights reserved.
//

import Foundation

/*
The purpose of this abstraction is to hide details of particular Codable objects (GitHub, BitBucket ...)
and expose universal interface that are used in the app to show user info
*/

class User {
    var login:String!
    var avatarUrl:URL?
    var followers:Int?
    var following:Int?
    var bio:String?
    var email:String?
    var createdAt:Date?
    var publicRepos:Int?
    var reposUrl:URL?

    private init() {}
    
    private init(_ user: GitHubUser) {
        populateFromGitHub(user)
    }
    
    private func populateFromGitHub(_ user: GitHubUser) {
        self.login = user.login
        self.avatarUrl = user.avatarUrl
        self.followers = user.followers
        self.following = user.following
        self.bio = user.bio
        self.email = user.email
        self.createdAt = user.createdAt
        self.publicRepos = user.publicRepos
        self.reposUrl = user.reposUrl
    }
    
    func update<T>(`with` profile:T) {
        switch profile {
        case let user as GitHubUser: populateFromGitHub(user)
        default: break
        }
    }

    static func `for`<T:Codable>(_ object:T) -> User {
        switch object {
        case let user as GitHubUser: return User(user)
        default: return User()
        }
    }
}
