//
//  Apps.swift
//  
//
//  Created by ned on 09/01/23.
//

import Foundation

public enum Apps: HTTPEndpoint {
    case list(type: AppType, page: Int = 1)
    case detail(type: AppType, trackid: String)
    
    public func queryItems() -> [URLQueryItem]? {
        let baseItems: [URLQueryItem] = [
            .init(name: "action", value: "search")
        ]
        switch self {
        case .list(let type, let page):
            return baseItems + [
                .init(name: "type", value: type.rawValue),
                .init(name: "page", value: String(page))
            ]
        case .detail(let type, let trackid):
            return baseItems + [
                .init(name: "type", value: type.rawValue),
                .init(name: "trackid", value: trackid)
            ]
        }
    }
}

public enum AppType: String {
    case ios
    case macos = "osx"
    case cydia
    case books
}
