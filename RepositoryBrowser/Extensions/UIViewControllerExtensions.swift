//
//  UIViewControllerExtensions.swift
//  RepositoryBrowser
//
//  Created by DDragutan on 3/31/20.
//  Copyright © 2020 DDragutan. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showError(_ error: Error?) {
        guard let error = error else {
            return
        }
        
        let title = NSLocalizedString("error", comment: "").capitalized
        showMessage(title: title, message: error.localizedDescription)
    }
    
    func showMessage(title:String?, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: NSLocalizedString("ok", comment: "").uppercased(), style: .default, handler: nil)
        alertController.addAction(dismissAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
