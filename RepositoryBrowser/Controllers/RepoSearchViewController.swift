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
    private let searchBar = UISearchBar()

    
    private var repositories:[Repository] = [] {
        didSet {
            filteredRepositories = repositories
        }
    }

    private var filteredRepositories:[Repository] = [] {
        didSet {
            tableDataSource.repositories = filteredRepositories
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(goBack))
//        if #available(iOS 13, *) {
//            //
//        } else {
//        }

        searchBar.autocapitalizationType = .none
        searchBar.showsCancelButton = true
        searchBar.placeholder = NSLocalizedString("search-repositories", comment: "")
        searchBar.delegate = self
        
        view.addSubview(headerView)
        view.addSubview(searchBar)
        view.addSubview(tableView)
        tableView.dataSource = tableDataSource
        tableView.delegate = self

        headerView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            searchBar.leftAnchor.constraint(equalTo: headerView.leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: headerView.rightAnchor)
        ])

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
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
    
    @objc func goBack() {
        dismiss(animated: true, completion: nil)
    }
}

extension RepoSearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            filteredRepositories = repositories.filter {
                return $0.name.lowercased().starts(with: searchText)
            }
        } else {
            filteredRepositories = repositories
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        filteredRepositories = repositories
    }
}

extension RepoSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < filteredRepositories.count else {
            return
        }
        
        if let url = filteredRepositories[indexPath.row].htmlUrl {
            UIApplication.shared.open(url)
        }
    }
}



private class HeaderView: UIView {
    
    private let imageSize = CGSize(width: 150, height: 150)
    private let imageView = UIImageView()
    private let nameLabel = HeaderView.labelFactory()
    private let emailLabel = HeaderView.labelFactory()
    private let locationLabel = HeaderView.labelFactory()
    private let joinDateLabel = HeaderView.labelFactory()
    private let followersLabel = HeaderView.labelFactory()
    private let followingLabel = HeaderView.labelFactory()
    private let bioLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUI() {
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.contentMode = .scaleAspectFill

        let vStack = UIStackView(arrangedSubviews: [nameLabel, emailLabel, locationLabel, joinDateLabel, followersLabel, followingLabel])
        vStack.axis = .vertical
        vStack.alignment = .leading
        vStack.spacing = 10

        bioLabel.numberOfLines = 0
        bioLabel.lineBreakMode = .byWordWrapping
        
        vStack.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(imageView)
        addSubview(vStack)
        addSubview(bioLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            imageView.rightAnchor.constraint(equalTo: self.centerXAnchor, constant: -20),
            imageView.widthAnchor.constraint(equalToConstant: imageSize.width),
            imageView.heightAnchor.constraint(equalToConstant: imageSize.height)
        ])
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            vStack.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: 20),
            vStack.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
        ])

        NSLayoutConstraint.activate([
            bioLabel.topAnchor.constraint(equalTo: vStack.bottomAnchor, constant: 15),
            bioLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bioLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            bioLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
        ])

    }
    
    func configure(`for` user: User) {
        nameLabel.text = user.login
        emailLabel.text = user.email ?? NSLocalizedString("no-email", comment: "")
        locationLabel.text = user.location ?? NSLocalizedString("no-location", comment: "")
        followersLabel.text = String(format: NSLocalizedString("followers", comment: ""), (user.followers ?? 0))
        followingLabel.text = String(format: NSLocalizedString("following", comment: ""), (user.following ?? 0))
        if let date = user.createdAt {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, YYYY"
            joinDateLabel.text = dateFormatter.string(from: date)
        } else {
            joinDateLabel.text = NSLocalizedString("no-join-date", comment: "")
        }
        
        bioLabel.text = user.bio
        
        if let avatarUrl = user.avatarUrl {
            NetworkRequest.shared.downloadImage(url: avatarUrl) { [weak self] image, _ in
                DispatchQueue.main.async {
                    guard let strongSelf = self else {
                        return
                    }
                    
                    strongSelf.imageView.image = image
                }
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
