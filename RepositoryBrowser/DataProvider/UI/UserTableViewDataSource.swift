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
    
    var users:[UserObject]?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let users = users, indexPath.row < users.count else {
            return TableViewCellFactory.dummyCell()
        }
        
        return TableViewCellFactory.userCell(for: tableView, indexPath: indexPath, user: users[indexPath.row])
    }
    
}
