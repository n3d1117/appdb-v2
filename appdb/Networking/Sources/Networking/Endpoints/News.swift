//
//  News.swift
//  
//
//  Created by ned on 07/01/23.
//

import Foundation

public enum News: HTTPEndpoint {
    case list(limit: Int)
    case detail(id: String)
    
    var path: String { "get_pages" }
    
    public var queryItems: [URLQueryItem] {
        let baseItems: [URLQueryItem] = [
            .init(name: "category", value: "news")
        ]
        switch self {
        case .list(let limit):
            return baseItems + [.init(name: "length", value: String(limit))]
        case .detail(let id):
            return baseItems + [.init(name: "id", value: id)]
        }
    }
}
