//
//  UsersRequest.swift
//  RepositoryBrowser
//
//  Created by DDragutan on 3/31/20.
//  Copyright © 2020 DDragutan. All rights reserved.
//

import Foundation

protocol UsersRequest {
    func getList(completionHandler: @escaping (UserList?, Error?) -> Void)
    func getUser(completionHandler: @escaping (User?, Error?) -> Void)
}


/*
 This is a wrapper for DataRequest to facilitate post-Decoding logic,
 to map service specific object (GitHubUserList) to UserList
 that will be passed to views/controllers to show movies list and details
 */
struct UsersRequestImpl: UsersRequest {
    private let request:DataRequest
    
    init(request: DataRequest) {
        self.request = request
    }

    /*
     this method executes JSONRequest and calls factory method to create UserList from GitHubUserList
     */
    func getList(completionHandler: @escaping (UserList?, Error?) -> Void) {
        request.execute { (decodedObject:Codable?, error:Error?) in
            guard let decodedObject = decodedObject else {
                completionHandler(nil, error)
                return
            }

            completionHandler(UserList.for(decodedObject), nil)
        }
    }
    
    func getUser(completionHandler: @escaping (User?, Error?) -> Void) {
        
    }
}
