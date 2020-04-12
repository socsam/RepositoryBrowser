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

    private let searchController = ViewControllerFactory.usersSearch()
    private let tableView = TableVewFactory.userList()
    private let tableDataSource = UserTableViewDataSource()
    private let activityIndicator = ViewFactory.activityIndicator()
    
    private var userToSearch:String?

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
        
        var title = ""
        switch dataSourceType {
        case .GitHub:
            title = String(format: NSLocalizedString("service-searcher", comment: ""), NSLocalizedString("github", comment: ""))
        default:
            break
        }
        
        navigationItem.title = title
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(backToLogin))
        
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = NSLocalizedString("search-for-users", comment: "")
        
        view.addSubview(tableView)
        tableView.dataSource = tableDataSource
        tableView.prefetchDataSource = self
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
        
        tableDataSource.removeAll()
        tableView.reloadData()

        activityIndicator.startAnimating()
        request.getList { [weak self] result in
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }
                
                switch result {
                case .success(let list):
                    strongSelf.activityIndicator.stopAnimating()
                    
                    /*
                     github api has limit about 1000 results for logged in users and about 300 for guets, not the number in list.totalCount
                     and if user keep scrolling long enough new cells will stop to appear
                     even though scroll indicator will show that there is much more to show
                     */
                    strongSelf.tableDataSource.totalCount = list.totalCount ?? 0
                    strongSelf.tableDataSource.users = list.users ?? []
                    
                    //inform user that no ithub users were found
                    //normally it should a custom cell or a view but for a test project an alert will suffice
                    if list.users?.count == 0 {
                        strongSelf.searchController.showMessage(title: nil, message: NSLocalizedString("search-no-results", comment: ""))
                    }
                    
                    strongSelf.tableView.reloadData()
                
                case .failure(let error):
                    if let error = error as NSError? {
                        //don't show error if request was canceled
                        if error.code != NSURLErrorCancelled {
                            strongSelf.activityIndicator.stopAnimating()
                            strongSelf.searchController.showError(error)
                        }
                    } else {
                        strongSelf.activityIndicator.stopAnimating()
                        strongSelf.showMessage(title: NSLocalizedString("error", comment: "").uppercased(), message: NSLocalizedString("uknown-error", comment: "").capitalized)
                    }
                }
            }
        }
    }
    
    @objc private func loadMoreData(rowsToReload:[IndexPath]) {
        guard let request = dataRequest else { return }
        
        request.getList { [weak self] result /*userList, error*/ in
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }
                
                switch result {
                case .success(let usersList):
                    if let additionalUsers = usersList.users {
                        strongSelf.tableDataSource.append(additionalUsers)
                        strongSelf.tableView.reloadRows(at: rowsToReload, with: .none)
                    }
                case .failure(_): break
                }
            }
        }
    }
    
    @objc func backToLogin() {
        searchController.isActive = false
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
}


extension UserSearchViewController: UISearchBarDelegate {
    
    /*
     cancel all running network requests
     initiate new search request
     */
    @objc public func doSearch() {
        guard let userToSearch = userToSearch, !userToSearch.isEmpty else {
            return
        }
        
        RequestFactory.cancelAll()
        dataRequest = RequestFactory.searchUsers(in: dataSourceType, keyword: userToSearch)
        reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            userToSearch = searchText
            // to limit network activity, reload half a second after last key press.
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.doSearch), object: nil)
            perform(#selector(self.doSearch), with: nil, afterDelay: 0.5)
        } else {
            userToSearch = nil
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        userToSearch = nil
        RequestFactory.cancelAll()
        tableDataSource.removeAll()
        tableView.reloadData()
    }

}

extension UserSearchViewController: UITableViewDelegate {
    /*
     download images only for visible cells
     */
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let user = tableDataSource.get(at: indexPath) else {
            return
        }
        
        if let avatarUrl = user.avatarUrl {
            RequestFactory.downloadImage(url: avatarUrl) { result in
                DispatchQueue.main.async {
                    if let image = try? result.get() {
                        if let cellToUpdate = tableView.cellForRow(at: indexPath) as? UserTableViewCell {
                            cellToUpdate.setImage(image)
                        }
                    }
                }
            }
        }
        
        RequestFactory.getUserProfile(for: user, from: dataSourceType)?.update(user) { result in
            DispatchQueue.main.async {
                if let updatedUser = try? result.get() {
                    if let cellToUpdate = tableView.cellForRow(at: indexPath) as? UserTableViewCell {
                        cellToUpdate.updateNumberOfRepos(for: updatedUser)
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let user = tableDataSource.get(at: indexPath) else {
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let repoVC = ViewControllerFactory.repositoryList(for: user, dataSource: dataSourceType)
        repoVC.modalPresentationStyle = .overFullScreen
        searchController.present(repoVC, animated: true, completion: nil)
    }
}


extension UserSearchViewController: UITableViewDataSourcePrefetching {

    /*
     this methods can be called multiple times with the same IndexPath
     */
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let userToSearch = userToSearch, !userToSearch.isEmpty else {
            return
        }

        //check if data already requested for the particular cell
        if indexPaths.contains(where: isLoadingCell) {
            let nextPage = tableDataSource.increasePage()
            dataRequest = RequestFactory.searchUsers(in: dataSourceType, keyword: userToSearch, page: nextPage)
            loadMoreData(rowsToReload: indexPaths)
        }
    }
    
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return tableDataSource.get(at: indexPath) == nil
    }

}
