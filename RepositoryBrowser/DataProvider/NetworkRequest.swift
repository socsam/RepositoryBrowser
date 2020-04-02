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

    public func getData(url:URL, completionHandler: @escaping (Data?, Error?) -> Void) {
        session.dataTask(with: url) { (data, response, error) in
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
