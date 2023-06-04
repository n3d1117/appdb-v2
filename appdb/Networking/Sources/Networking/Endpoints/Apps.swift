//
//  Apps.swift
//  
//
//  Created by ned on 09/01/23.
//

import Foundation

public enum Apps: HTTPEndpoint {
    case list(type: AppType, length: Int = 25, page: Int = 1)
    case detail(type: AppType, trackid: Int)
    
    var path: String { "search" }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .list(let type, let length, let page):
            return [
                .init(name: "type", value: type.rawValue),
                .init(name: "start", value: String((page - 1) * length)),
                .init(name: "length", value: String(length))
            ]
        case .detail(let type, let trackid):
            return [
                .init(name: "type", value: type.rawValue),
                .init(name: "trackid", value: String(trackid))
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
