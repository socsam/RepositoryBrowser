//
//  UserList.swift
//  RepositoryBrowser
//
//  Created by DDragutan on 3/31/20.
//  Copyright © 2020 DDragutan. All rights reserved.
//

import Foundation

/*
The purpose of these protocol is to hide details of particular Codable objects (GitHub, BitBucket ...)
and expose universal interface that are used in the app to show list of users
*/

protocol UserListObject {
    var totalCount:Int? {get}
    var incompleteResults:Bool? {get}
    var users:[User]? {get}
}


struct UserList: UserListObject {
    var totalCount:Int?
    var incompleteResults:Bool?
    var users:[User]?

    private init() {}
    
    private init(_ list: GitHubUserList) {
        self.totalCount = list.totalCount
        self.incompleteResults = list.incompleteResults
        
        if let users = list.users {
            self.users = users.map { User.for($0) }
        }

    }

    static func `for`<Codable>(_ object:Codable) -> UserList? {
        switch object {
        case let list as GitHubUserList: return UserList(list)
        default: return nil
        }
    }
}
