//
//  RepositoryRequest.swift
//  RepositoryBrowser
//
//  Created by DDragutan on 4/1/20.
//  Copyright © 2020 DDragutan. All rights reserved.
//

import Foundation

protocol RepositoryRequest {
    func getList(completionHandler: @escaping ([Repository]?, Error?) -> Void)
}


/*
 This is a wrapper for DataRequest to facilitate post-Decoding logic,
 to map service specific object (GitHubUserList) to UserList
 that will be passed to views/controllers to show user list and details
 */
struct RepositoryRequestImpl: RepositoryRequest {
    private let request:DataRequest
    
    init(request: DataRequest) {
        self.request = request
    }

    /*
     this method executes JSONRequest and calls factory method to create UserList from GitHubUserList
     */
    func getList(completionHandler: @escaping ([Repository]?, Error?) -> Void) {
        request.execute { (decodedObject:Codable?, error:Error?) in
            guard let decodedObject = decodedObject as? [Codable] else {
                completionHandler(nil, error)
                return
            }
            
            let repositories = decodedObject.map { Repository.for($0) }
            completionHandler(repositories, nil)
        }
    }
}
