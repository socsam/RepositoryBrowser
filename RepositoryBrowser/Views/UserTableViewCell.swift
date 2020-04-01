//
//  UserTableViewCell.swift
//  RepositoryBrowser
//
//  Created by DDragutan on 3/31/20.
//  Copyright © 2020 DDragutan. All rights reserved.
//

import Foundation
import UIKit

class UserTableViewCell: UITableViewCell {

    static let identifier = "UserTableViewCell"
    
    private let imageSize = CGSize(width: 80, height: 80)
    
    private let userImageView = UIImageView()
    private let nameLabel = UILabel()
    private let numberOfRepos = UILabel()
    private let separatorView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUI() {
        separatorView.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 0.25)
        
        nameLabel.numberOfLines = 1
        nameLabel.lineBreakMode = .byTruncatingTail
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.textColor = .darkGray

        numberOfRepos.numberOfLines = 1
        numberOfRepos.font = UIFont.boldSystemFont(ofSize: 14)
        numberOfRepos.textColor = .black

        userImageView.setContentHuggingPriority(.required, for: .horizontal)
        userImageView.contentMode = .scaleAspectFill
        numberOfRepos.setContentHuggingPriority(.required, for: .horizontal)

        contentView.addSubview(separatorView)
        contentView.addSubview(userImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(numberOfRepos)

        userImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        numberOfRepos.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            separatorView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 2)
        ])

        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            userImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            userImageView.bottomAnchor.constraint(equalTo: separatorView.topAnchor),
            userImageView.widthAnchor.constraint(equalToConstant: imageSize.width),
            userImageView.heightAnchor.constraint(equalToConstant: imageSize.height)
        ])

        NSLayoutConstraint.activate([
            numberOfRepos.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor),
            numberOfRepos.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
        ])

        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor),
            nameLabel.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 10),
            nameLabel.rightAnchor.constraint(equalTo: numberOfRepos.leftAnchor, constant: -10),
        ])

    }
    
    func configure(`for` user: UserObject) {
        nameLabel.text = user.login
        let reposCount = String(user.publicRepos ?? 0)
        numberOfRepos.text = String(format: NSLocalizedString("repos-count", comment: ""), reposCount)
    }
    
    func setImage(_ image: UIImage?) {
        userImageView.image = image ?? UIImage(named: "placeholder")
        setNeedsLayout()
    }
}
