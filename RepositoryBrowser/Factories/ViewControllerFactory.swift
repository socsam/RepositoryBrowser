//
//  ViewControllerFactory.swift
//  RepositoryBrowser
//
//  Created by DDragutan on 3/31/20.
//  Copyright © 2020 DDragutan. All rights reserved.
//

import Foundation
import UIKit

struct ViewControllerFactory {
    
    static func usersList(from dataSource: DataSourceType = .GitHub, embedInNavigation:Bool = true) -> UIViewController {
        let request = RequestFactory.searchUsers(in: dataSource, keyword: "john")
        let repositoriesVC = UserSearchViewController(dataSource: dataSource, request: request)
        return embedInNavigation ? UINavigationController(rootViewController: repositoriesVC) : repositoriesVC
    }

    static func repositoryList(`for` user: User, dataSource: DataSourceType, embedInNavigation:Bool = true) -> UIViewController {
        let request = RequestFactory.getRepositories(for: user)
        let repositoriesVC = RepoSearchViewController(user: user, dataSource: dataSource, request: request)
        return embedInNavigation ? UINavigationController(rootViewController: repositoriesVC) : repositoriesVC
    }

    static func usersSearch() -> UISearchController {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false

        return searchController
    }
}
