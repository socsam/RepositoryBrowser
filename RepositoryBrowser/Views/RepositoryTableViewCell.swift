//
//  RepositoryTableViewCell.swift
//  RepositoryBrowser
//
//  Created by DDragutan on 4/1/20.
//  Copyright © 2020 DDragutan. All rights reserved.
//

import Foundation
import UIKit

class RepositoryTableViewCell: UITableViewCell {

    static let identifier = "RepositoryTableViewCell"
    
    private let nameLabel = UILabel()
    private let numberOfStarsLabel = UILabel()
    private let numberOfForksLabel = UILabel()
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

        contentView.addSubview(separatorView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(numberOfForksLabel)
        contentView.addSubview(numberOfStarsLabel)

        separatorView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfStarsLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfForksLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            separatorView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 2)
        ])

        NSLayoutConstraint.activate([
            numberOfForksLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            numberOfForksLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
        ])

        NSLayoutConstraint.activate([
            numberOfStarsLabel.topAnchor.constraint(equalTo: numberOfForksLabel.bottomAnchor, constant: 10),
            numberOfStarsLabel.rightAnchor.constraint(equalTo: numberOfForksLabel.rightAnchor),
            numberOfStarsLabel.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -10),
        ])

        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            nameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5)
        ])

    }
    
    func configure(`for` repository: Repository) {
        nameLabel.text = repository.name
        
        let forksCount = repository.forksCount ?? 0
        numberOfForksLabel.text = String(format: NSLocalizedString("forks-count", comment: ""), forksCount)
        
        let starsCount = repository.starsCount ?? 0
        numberOfStarsLabel.text = String(format: NSLocalizedString("stars-count", comment: ""), starsCount)
    }
}
