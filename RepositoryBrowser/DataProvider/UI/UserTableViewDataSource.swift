//
//  UserTableViewDataSource.swift
//  RepositoryBrowser
//
//  Created by DDragutan on 3/31/20.
//  Copyright © 2020 DDragutan. All rights reserved.
//

import Foundation
import UIKit

class UserTableViewDataSource: NSObject, UITableViewDataSource {
    
    private(set) var page:Int = 1
    var totalCount:Int = 0
    var users:[User] = []
    
    func increasePage() -> Int {
        page += 1
        return page
    }
    
    func append(_ additionalUsers: [User]) {
        users.append(contentsOf: additionalUsers)
    }
    
    func get(at indexPath: IndexPath) -> User? {
        guard indexPath.row < users.count else {
            return nil
        }
        
        return users[indexPath.row]
    }
    
    func removeAll() {
        users = []
        totalCount = 0
        page = 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let user = get(at: indexPath) else {
            return TableViewCellFactory.dummyCell()
        }
        
        return TableViewCellFactory.userCell(for: tableView, indexPath: indexPath, user: user)
    }
    
}
