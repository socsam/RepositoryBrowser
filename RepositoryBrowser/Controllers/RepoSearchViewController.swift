//
//  RepoSearchViewController.swift
//  RepositoryBrowser
//
//  Created by DDragutan on 4/1/20.
//  Copyright © 2020 DDragutan. All rights reserved.
//

import Foundation
import UIKit

class RepoSearchViewController: UIViewController {

    private var user:User!
    private var dataSourceType:DataSourceType!
    private var dataRequest:RepositoryRequest?

    private let tableView = TableVewFactory.repositoryList()
    private let tableDataSource = RepositoryTableViewDataSource()
    private let activityIndicator = ViewFactory.activityIndicator()
    private let headerView = HeaderView()

    
    private var repositories:[Repository] = [] {
        didSet {
            tableDataSource.repositories = repositories
            tableView.reloadData()
        }
    }
    
    init(user: User, dataSource: DataSourceType, request: RepositoryRequest?) {
        self.user = user
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        
//        searchController.searchBar.delegate = self
        
        view.addSubview(headerView)
        view.addSubview(tableView)
        tableView.dataSource = tableDataSource

        headerView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
        
        headerView.configure(for: user)
    }
    
    @objc private func reloadData() {
        guard let request = dataRequest else { return }
        
        activityIndicator.startAnimating()
        repositories = []
        request.getList { [weak self] repositories, error in
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }
                
                if let repositories = repositories {
                    strongSelf.activityIndicator.stopAnimating()
                    strongSelf.repositories = repositories
                    
                    //inform user that no repositories users were found
                    //normally it should a custom cell or a view but for a test project an alert will suffice
                    if repositories.count == 0 {
                        strongSelf.showMessage(title: nil, message: NSLocalizedString("search-no-results", comment: ""))
                    }
                } else {
                    strongSelf.repositories = []
                    if let error = error as NSError? {
                        //don't show error if request was canceled
                        if error.code != NSURLErrorCancelled {
                            strongSelf.activityIndicator.stopAnimating()
                            strongSelf.showError(error)
                        }
                    } else {
                        strongSelf.activityIndicator.stopAnimating()
                        strongSelf.showMessage(title: NSLocalizedString("error", comment: "").uppercased(), message: NSLocalizedString("uknown-error", comment: "").capitalized)
                    }
                }
            }
        }
    }
}


private class HeaderView: UIView {
    
    private let imageSize = CGSize(width: 150, height: 150)
    private let imageView = UIImageView()
    private let emailLabel = HeaderView.labelFactory()
    private let locationLabel = HeaderView.labelFactory()
    private let joinDateLabel = HeaderView.labelFactory()
    private let followersLabel = HeaderView.labelFactory()
    private let followingLabel = HeaderView.labelFactory()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUI() {
        addSubview(imageView)
        addSubview(emailLabel)
        addSubview(locationLabel)
        addSubview(joinDateLabel)
        addSubview(followersLabel)
        addSubview(followingLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.contentMode = .scaleAspectFill
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.widthAnchor.constraint(equalToConstant: imageSize.width),
            imageView.heightAnchor.constraint(equalToConstant: imageSize.height)
        ])
    }
    
    func configure(`for` user: User) {
        guard let avatarUrl = user.avatarUrl else {
            return
        }
        
        NetworkRequest.shared.downloadImage(url: avatarUrl) { [weak self] image, _ in
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.imageView.image = image
            }
        }
    }
    
    private static func labelFactory() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    
    func configure(with user: User) {
        
    }
}
