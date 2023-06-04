//
//  Endpoint.swift
//  
//
//  Created by ned on 07/01/23.
//

import Foundation

protocol HTTPEndpoint {
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}

public enum Endpoint {
    case apps(Apps)
    case news(News)
    case links(Links)
}

extension Endpoint: HTTPEndpoint {
    public var path: String {
        switch self {
        case .apps(let appsEndpoint): return appsEndpoint.path
        case .news(let newsEndpoint): return newsEndpoint.path
        case .links(let linksEndpoint): return linksEndpoint.path
        }
    }
    public var queryItems: [URLQueryItem] {
        switch self {
        case .apps(let appsEndpoint): return appsEndpoint.queryItems
        case .news(let newsEndpoint): return newsEndpoint.queryItems
        case .links(let linksEndpoint): return linksEndpoint.queryItems
        }
    }
}
