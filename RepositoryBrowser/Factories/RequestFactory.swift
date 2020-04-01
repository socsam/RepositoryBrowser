//
//  RequestFactory.swift
//  RepositoryBrowser
//
//  Created by DDragutan on 3/31/20.
//  Copyright © 2020 DDragutan. All rights reserved.
//

import Foundation
import UIKit

struct RequestFactory {
    static func searchUsers(in dataSource: DataSourceType, keyword: String?) -> UsersRequest? {
        guard let url = URLFactory.getSearchURL(for: dataSource, keyword: keyword) else {
            return nil
        }

        var request: DataRequest
        switch dataSource {
        case .GitHub: request = JSONRequest(requestType: GitHubUserList.self, url: url)
        }

        return UsersRequestImpl(request: request)
    }
    
    static func getUserProfile(`for` user: User, from dataSource: DataSourceType) -> UsersRequest? {
        guard let url = URLFactory.getUserURL(for: dataSource, keyword: user.login) else {
            return nil
        }

        var request: DataRequest
        switch dataSource {
        case .GitHub: request = JSONRequest(requestType: GitHubUser.self, url: url)
        }

        return UsersRequestImpl(request: request)
    }
    
    static func downloadImage(url:URL, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        NetworkRequest.shared.downloadImage(url: url) { image, error in
            completionHandler(image, error)
        }
    }
    
    static func cancelAll() {
        NetworkRequest.shared.cancelAllTasks()
    }
}
