//
//  Endpoint.swift
//  
//
//  Created by ned on 07/01/23.
//

import Foundation

protocol HTTPEndpoint {
    func queryItems() -> [URLQueryItem]?
}

public enum Endpoint {
    case news(News)
}

extension Endpoint: HTTPEndpoint {
    public func queryItems() -> [URLQueryItem]? {
        switch self {
        case .news(let newsEndpoint): return newsEndpoint.queryItems()
        }
    }
}
