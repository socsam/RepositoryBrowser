//
//  ConfigReader.swift
//  RepositoryBrowser
//
//  Created by DDragutan on 3/31/20.
//  Copyright © 2020 DDragutan. All rights reserved.
//

import Foundation

enum ConfigKey:String {
    case searchUrl = "SEARCH_URL"
    case userUrl = "USER_URL"
}

struct ConfigReader {
    
    private static let prefixes:[DataSourceType:String] = [
        .GitHub:"GITHUB_"
    ]
    
    static func getValue(`for` key: ConfigKey, dataSource: DataSourceType) -> String? {
        guard let prefix = prefixes[dataSource] else {
            return nil
        }
        
        let key = prefix + key.rawValue
        return Bundle.main.object(forInfoDictionaryKey: key) as? String
    }
    
}
