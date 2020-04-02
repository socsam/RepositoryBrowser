//
//  RepositoryTableViewDataSource.swift
//  RepositoryBrowser
//
//  Created by DDragutan on 4/1/20.
//  Copyright © 2020 DDragutan. All rights reserved.
//

import Foundation
import UIKit

class RepositoryTableViewDataSource: NSObject, UITableViewDataSource {
    
    var repositories:[Repository]?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let repositories = repositories, indexPath.row < repositories.count else {
            return TableViewCellFactory.dummyCell()
        }
        
        return TableViewCellFactory.repositoryCell(for: tableView, indexPath: indexPath, repository: repositories[indexPath.row])
    }
    
}
