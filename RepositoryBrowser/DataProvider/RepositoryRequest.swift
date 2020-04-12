//
//  RepositoryRequest.swift
//  RepositoryBrowser
//
//  Created by DDragutan on 4/1/20.
//  Copyright © 2020 DDragutan. All rights reserved.
//

import Foundation

protocol RepositoryRequest {
    func getList(completion: @escaping (Result<[Repository], Error>) -> Void)
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
    func getList(completion: @escaping (Result<[Repository], Error>) -> Void) {
        request.execute { result in
            switch result {
            case .success(let decodedObject):
                if let repositoriesRaw = decodedObject as? [Codable] {
                    let repositories = repositoriesRaw.map { Repository.for($0) }
                    completion(.success(repositories))
                }
            case .failure(let error): completion(.failure(error))
            }
        }
    }
}
