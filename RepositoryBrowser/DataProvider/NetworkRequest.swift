//
//  NetworkRequest.swift
//  RepositoryBrowser
//
//  Created by DDragutan on 3/31/20.
//  Copyright © 2020 DDragutan. All rights reserved.
//

import Foundation
import UIKit

enum NetworkRequestError: Error {
    case loadData
    case loadImage
}

class NetworkRequest {
    
    public static let shared = NetworkRequest()
    
    private var login:String?
    private var password:String?
    
    private var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
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

    public func getData(url:URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let request = getRequest(for: url)
        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(NetworkRequestError.loadData))
            }
        }.resume()
    }

    public func downloadImage(url:URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        if let image = self.cache.object(forKey: url as NSURL) {
            completion(.success(image))
        } else {
            session.downloadTask(with: url, completionHandler: { [weak self] (localURL, response, error) in
                guard let strongSelf = self, let localURL = localURL else {
                    return
                }
                
                do {
                    let data = try Data(contentsOf: localURL)
                    if let image = UIImage(data: data) {
                        strongSelf.cache.setObject(image, forKey: url as NSURL)
                        completion(.success(image))
                    } else {
                        completion(.failure(NetworkRequestError.loadImage))
                    }
                } catch let readingDataError {
                    completion(.failure(readingDataError))
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
