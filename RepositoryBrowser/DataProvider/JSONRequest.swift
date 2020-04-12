//
//  JSONRequest.swift
//  RepositoryBrowser
//
//  Created by DDragutan on 3/31/20.
//  Copyright © 2020 DDragutan. All rights reserved.
//

import Foundation

class JSONRequest<T:Codable> {
    let requestType:T.Type
    let url:URL
    
    init(requestType: T.Type, url: URL) {
        self.requestType = requestType
        self.url = url
    }
}

extension JSONRequest: DataRequest {
    func execute(completion: @escaping (Result<Codable, Error>) -> Void) {
        let requestType = self.requestType
        NetworkRequest.shared.getData(url: url) { result in
            switch result {
            case .success(let data):
                 do {
                     let decoder = JSONDecoder()
                     decoder.dateDecodingStrategy = .iso8601
                     let json = try decoder.decode(requestType, from: data)
                    completion(.success(json))
                 } catch let decodingError {
                    completion(.failure(decodingError))
                }
                
            case .failure(let error): completion(.failure(error))
            }
        }
    }
}
