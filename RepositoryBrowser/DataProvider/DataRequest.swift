//
//  DataRequest.swift
//  RepositoryBrowser
//
//  Created by DDragutan on 3/31/20.
//  Copyright © 2020 DDragutan. All rights reserved.
//

import Foundation

/*
 Specific implementation will conform to this protocol JSON, XML, GraphQL
 */

protocol DataRequest {
    func execute(completionHandler: @escaping (Codable?, Error?) -> Void)
}
