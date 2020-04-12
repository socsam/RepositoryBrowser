//
//  UsersRequest.swift
//  RepositoryBrowser
//
//  Created by DDragutan on 3/31/20.
//  Copyright © 2020 DDragutan. All rights reserved.
//

import Foundation

protocol UsersRequest {
    func getList(completion: @escaping (Result<UserList, Error>) -> Void)
    func update(_ user:User, completion: @escaping (Result<User, Error>) -> Void)
}


/*
 This is a wrapper for DataRequest to facilitate post-Decoding logic,
 to map service specific object (GitHubUserList) to UserList
 that will be passed to views/controllers to show users list and details
 */
struct UsersRequestImpl: UsersRequest {
    private let request:DataRequest
    
    init(request: DataRequest) {
        self.request = request
    }

    /*
     this method executes JSONRequest and calls factory method to create UserList from GitHubUserList
     */
    func getList(completion: @escaping (Result<UserList, Error>) -> Void) {
        request.execute { result in
            switch result {
            case .success(let decodedObject): completion(UserList.for(decodedObject))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    func update(_ user:User, completion: @escaping (Result<User, Error>) -> Void) {
        request.execute { result in
            switch result {
            case .success(let decodedObject):
                user.update(with: decodedObject)
                completion(.success(user))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
}
