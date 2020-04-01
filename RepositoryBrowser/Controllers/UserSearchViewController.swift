//
//  UserSearchViewController.swift
//  RepositoryBrowser
//
//  Created by DDragutan on 3/31/20.
//  Copyright © 2020 DDragutan. All rights reserved.
//

import UIKit

class UserSearchViewController: UIViewController {
    
    private var dataSourceType:DataSourceType!
    private var dataRequest:UsersRequest?

    private let searchController = ViewControllerFactory.mediaSearch()
    private let tableView = TableVewFactory.userList()
    private let tableDataSource = UserTableViewDataSource()
    private let activityIndicator = ViewFactory.activityIndicator()

    private var users:[UserObject] = [] {
        didSet {
            tableDataSource.users = users
            tableView.reloadData()
        }
    }
    
    init(dataSource: DataSourceType, request: UsersRequest?) {
        self.dataSourceType = dataSource
        self.dataRequest = request
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        reloadData()
    }

    private func initUI() {
        view.backgroundColor = .white
        navigationItem.title = NSLocalizedString("users", comment: "").capitalized
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        
        searchController.searchBar.delegate = self
        
        view.addSubview(tableView)
        tableView.dataSource = tableDataSource
        tableView.delegate = self

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
    
    @objc private func reloadData() {
        guard let request = dataRequest else { return }
        
        activityIndicator.startAnimating()
        users = []
        request.getList { [unowned self] userList, error in
            DispatchQueue.main.async {
                if let users = userList?.users {
                    self.activityIndicator.stopAnimating()
                    self.users = users
                    
                    //inform user that no ithub users were found
                    //normally it should a custom cell or a view but for a test project an alert will suffice
                    if users.count == 0 {
                        self.searchController.showMessage(title: nil, message: NSLocalizedString("search-no-results", comment: ""))
                    }
                } else {
                    if let error = error as NSError? {
                        //don't show error if request was canceled
                        if error.code != NSURLErrorCancelled {
                            self.activityIndicator.stopAnimating()
                            self.searchController.showError(error)
                        }
                    } else {
                        self.activityIndicator.stopAnimating()
                        self.showMessage(title: NSLocalizedString("error", comment: "").uppercased(), message: NSLocalizedString("uknown-error", comment: "").capitalized)
                    }
                }
            }
        }
    }
}


extension UserSearchViewController: UISearchBarDelegate {
    
    /*
     cancel all running network requests
     initiate new search request
     */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        RequestFactory.cancelAll()
        dataRequest = RequestFactory.searchUsers(in: dataSourceType, keyword: searchBar.text)
        reloadData()
    }
    
}

extension UserSearchViewController: UITableViewDelegate {
    /*
     download images only for visible cells
     */
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row < users.count, let avatarUrl = users[indexPath.row].avatarUrl else {
            return
        }
        
        RequestFactory.downloadImage(url: avatarUrl) { image, _ in
            DispatchQueue.main.async {
                if let cellToUpdate = tableView.cellForRow(at: indexPath) as? UserTableViewCell {
                    cellToUpdate.setImage(image)
                }
            }
        }
    }
}
