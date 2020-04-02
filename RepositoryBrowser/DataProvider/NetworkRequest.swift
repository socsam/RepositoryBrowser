//
//  NetworkRequest.swift
//  RepositoryBrowser
//
//  Created by DDragutan on 3/31/20.
//  Copyright © 2020 DDragutan. All rights reserved.
//

import Foundation
import UIKit

class NetworkRequest {
    
    public static let shared = NetworkRequest()
    
    private var login:String?
    private var password:String?
    
    private var session: URLSession = {
        /*
         disable URLSession cache for debugging purpose to make sure custom cache implementation is working properly
         */
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad //reloadIgnoringLocalAndRemoteCacheData
//        config.urlCache = nil
        return URLSession.init(configuration: config)
    }()
    
    private var cache: NSCache<NSURL, UIImage> = NSCache()
    
    public func setCredentials(login: String, password: String) {
        self.login = login
        self.password = password
    }
    
    private func getRequest(`for` url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        if let login = login, let password = password {
            let loginString = "\(login):\(password)"
            if let base64LoginString = loginString.data(using: String.Encoding.utf8)?.base64EncodedString() {
                request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            }
        }
        
        return request
    }

    public func getData(url:URL, completionHandler: @escaping (Data?, Error?) -> Void) {
        let request = getRequest(for: url)
        session.dataTask(with: request) { (data, response, error) in
            if let error = error as NSError?, error.code != NSURLErrorCancelled {
                print(error.localizedDescription)
            }
            completionHandler(data, error)
        }.resume()
    }

    public func downloadImage(url:URL, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        if let image = self.cache.object(forKey: url as NSURL) {
            completionHandler(image, nil)
        } else {
            session.downloadTask(with: url, completionHandler: { [weak self] (localURL, response, error) in
                guard let strongSelf = self, let localURL = localURL else {
                    return
                }
                
                do {
                    let data = try Data(contentsOf: localURL)
                    if let image = UIImage(data: data) {
                        strongSelf.cache.setObject(image, forKey: url as NSURL)
                        completionHandler(image, nil)
                    } else {
                        completionHandler(nil, nil)
                    }
                } catch let readingDataError {
                    completionHandler(nil, readingDataError)
                }
            }).resume()
        }
    }
    
    public func cancelAllTasks() {
        session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach {
                $0.cancel()
            }
            
            downloadTasks.forEach {
                $0.cancel()
            }
        }
    }
}
