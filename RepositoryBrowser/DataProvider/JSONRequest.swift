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
    func execute(completionHandler: @escaping (Codable?, Error?) -> Void) {
        let requestType = self.requestType
        NetworkRequest.shared.getData(url: url) { data, error in
           guard let data = data else {
               completionHandler(nil, error)
               return
           }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let json = try decoder.decode(requestType, from: data)
                completionHandler(json, nil)
            } catch let decodingError {
               completionHandler(nil, decodingError)
           }
        }
    }
}
