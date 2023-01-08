//
//  Endpoint.swift
//  
//
//  Created by ned on 07/01/23.
//

import Foundation

public protocol AppdbEndpoint {
    func queryItems() -> [URLQueryItem]?
}

public enum Endpoint {
    case news(News)
}

extension Endpoint: AppdbEndpoint {
    public func queryItems() -> [URLQueryItem]? {
        switch self {
        case .news(let newsEndpoint): return newsEndpoint.queryItems()
        }
    }
}
