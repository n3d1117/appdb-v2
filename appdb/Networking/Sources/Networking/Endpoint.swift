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
    case apps(Apps)
    case news(News)
    case links(Links)
}

extension Endpoint: HTTPEndpoint {
    public func queryItems() -> [URLQueryItem]? {
        switch self {
        case .apps(let appsEndpoint): return appsEndpoint.queryItems()
        case .news(let newsEndpoint): return newsEndpoint.queryItems()
        case .links(let linksEndpoint): return linksEndpoint.queryItems()
        }
    }
}
