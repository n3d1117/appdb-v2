//
//  Apps.swift
//  
//
//  Created by ned on 09/01/23.
//

import Foundation

public enum Apps: HTTPEndpoint {
    case list(type: AppType, page: Int = 1)
    
    public func queryItems() -> [URLQueryItem]? {
        let baseItems: [URLQueryItem] = [
            .init(name: "action", value: "search")
        ]
        switch self {
        case .list(let appType, let page):
            return baseItems + [
                .init(name: "type", value: appType.rawValue),
                .init(name: "page", value: String(page))
            ]
        }
    }
}

extension Apps {
    public enum AppType: String {
        case ios
        case macos = "osx"
        case cydia
        case books
    }
}
