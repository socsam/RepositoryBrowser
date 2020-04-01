//
//  ViewFactory.swift
//  RepositoryBrowser
//
//  Created by DDragutan on 3/31/20.
//  Copyright © 2020 DDragutan. All rights reserved.
//

import Foundation
import UIKit

struct TableViewCellFactory {
    
    static func dummyCell() -> UITableViewCell {
        return UITableViewCell()
    }
    
    static func userCell(`for` tableView:UITableView, indexPath: IndexPath, user: UserObject) -> UserTableViewCell {
        var cell:UserTableViewCell! = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as? UserTableViewCell
        
        if cell == nil {
            cell = UserTableViewCell(style: .default, reuseIdentifier: UserTableViewCell.identifier)
        }
        
        cell.configure(for: user)
        cell.selectionStyle = .none

        return cell
    }
}

struct TableVewFactory {
    
    static func userList() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }
    
}

struct ViewFactory {
    
    static func activityIndicator() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.hidesWhenStopped = true
        return indicator
    }
}
