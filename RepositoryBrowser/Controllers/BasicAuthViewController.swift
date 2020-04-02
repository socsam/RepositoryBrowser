//
//  BasicAuthViewController.swift
//  RepositoryBrowser
//
//  Created by DDragutan on 4/1/20.
//  Copyright © 2020 DDragutan. All rights reserved.
//

import Foundation
import UIKit

class BasicAuthViewController: UIViewController {
    
    private var dataSourceType:DataSourceType!
    
    private let loginTF = textFieldFactory(placeHolder: NSLocalizedString("login-placeholder", comment: ""))
    private let passwordTF = textFieldFactory(placeHolder: NSLocalizedString("password-placeholder", comment: ""), isSecure: true)
    private let loginButton = UIButton()
    private let skipButton = UIButton()
    
    init(dataSource: DataSourceType) {
        self.dataSourceType = dataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    
    private func initUI() {
        view.backgroundColor = .white
        
        var title = ""
        switch dataSourceType {
        case .GitHub:
            title = String(format: NSLocalizedString("login-to", comment: ""), NSLocalizedString("github", comment: ""))
        default:
            break
        }
        navigationItem.title = title
        
        loginButton.setTitle(NSLocalizedString("login-button", comment: ""), for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        loginButton.setTitleColor(.blue, for: .normal)
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)

        skipButton.setTitle(NSLocalizedString("skip-button", comment: ""), for: .normal)
        skipButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        skipButton.setTitleColor(.gray, for: .normal)
        skipButton.addTarget(self, action: #selector(skip), for: .touchUpInside)

        view.addSubview(loginTF)
        view.addSubview(passwordTF)
        view.addSubview(loginButton)
        view.addSubview(skipButton)

        loginTF.translatesAutoresizingMaskIntoConstraints = false
        passwordTF.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            loginTF.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            loginTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginTF.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
        ])

        NSLayoutConstraint.activate([
            passwordTF.topAnchor.constraint(equalTo: loginTF.bottomAnchor, constant: 10),
            passwordTF.leftAnchor.constraint(equalTo: loginTF.leftAnchor),
            passwordTF.widthAnchor.constraint(equalTo: loginTF.widthAnchor)
        ])

        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: passwordTF.bottomAnchor, constant: 10),
            loginButton.centerXAnchor.constraint(equalTo: passwordTF.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            skipButton.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor),
            skipButton.rightAnchor.constraint(equalTo: passwordTF.rightAnchor)
        ])

    }
    
    private static func textFieldFactory(placeHolder: String, isSecure: Bool = false) -> UITextField {
        let tf = UITextField()
        tf.isSecureTextEntry = isSecure
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.textAlignment = .center
        tf.font = UIFont.systemFont(ofSize: 22)
        tf.placeholder = placeHolder
        tf.layer.borderColor = UIColor.black.cgColor
        tf.layer.borderWidth = 1
        return tf
    }
}

//login or skip
extension BasicAuthViewController {
    @objc func login() {
        guard let login = loginTF.text, !login.isEmpty,
            let password = passwordTF.text, !password.isEmpty else {
                showMessage(title: nil, message: NSLocalizedString("provide-credentials", comment: ""))
                return
        }
        
        NetworkRequest.shared.setCredentials(login: login, password: password)
        presentUserSearch()
    }
    
    @objc func skip() {
        presentUserSearch()
    }
    
    private func presentUserSearch() {
        let vc = ViewControllerFactory.usersSearch(from: dataSourceType, embedInNavigation: true)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}
