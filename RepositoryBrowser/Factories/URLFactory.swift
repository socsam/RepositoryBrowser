//
//  URLFactory.swift
//  RepositoryBrowser
//
//  Created by DDragutan on 3/31/20.
//  Copyright © 2020 DDragutan. All rights reserved.
//

import Foundation

struct URLFactory {

    static func getSearchURL(`for` dataSource: DataSourceType, keyword: String?) -> URL? {
        guard let keyword = keyword?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let urlTemplate = ConfigReader.getValue(for: .searchUrl, dataSource: dataSource) else {
            return nil
        }
        
        switch dataSource {
        case .GitHub:
            let urlString = String(format: urlTemplate, keyword)
            return URL(string: urlString)
        }
    }

    static func getUserURL(`for` dataSource: DataSourceType, keyword: String?) -> URL? {
        guard let keyword = keyword?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let urlTemplate = ConfigReader.getValue(for: .userUrl, dataSource: dataSource) else {
            return nil
        }
        
        switch dataSource {
        case .GitHub:
            let urlString = String(format: urlTemplate, keyword)
            return URL(string: urlString)
        }
    }

}
