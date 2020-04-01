//
//  User.swift
//  RepositoryBrowser
//
//  Created by DDragutan on 3/31/20.
//  Copyright © 2020 DDragutan. All rights reserved.
//

import Foundation

/*
The purpose of these protocol is to hide details of particular Codable objects (GitHub, BitBucket ...)
and expose universal interface that are used in the app to show user info
*/

protocol UserObject {
    var id:Int? {get}
    var login:String? {get}
    var publicRepos:Int? {get}
    var avatarUrl:URL? {get}
    var followers:Int? {get}
    var following:Int? {get}
    var bio:String? {get}
    var email:String? {get}
    var createdAt:Date? {get}
}


class User: UserObject {
    var id:Int?
    var login:String?
    var publicRepos:Int?
    var avatarUrl:URL?
    var followers:Int?
    var following:Int?
    var bio:String?
    var email:String?
    var createdAt:Date?

    private init() {}
    
    private init(_ user: GitHubUser) {
        self.login = user.login
        self.publicRepos = user.publicRepos
        self.avatarUrl = user.avatarUrl
        self.followers = user.followers
        self.following = user.following
        self.bio = user.bio
        self.email = user.email
        self.createdAt = user.createdAt
    }

    static func `for`<T:Codable>(_ object:T) -> User {
        switch object {
        case let user as GitHubUser: return User(user)
        default: return User()
        }
    }
}
