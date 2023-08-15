//
//  News.swift
//  
//
//  Created by ned on 07/01/23.
//

import Foundation

public enum News: HTTPEndpoint {
    case list(length: Int = 25, page: Int = 1)
    case detail(id: String)
    
    var path: String { "get_pages" }
    
    public var queryItems: [URLQueryItem] {
        let baseItems: [URLQueryItem] = [
            .init(name: "category", value: "news")
        ]
        switch self {
        case .list(let length, let page):
            return baseItems + [
                .init(name: "start", value: String((page - 1) * length)),
                .init(name: "length", value: String(length))
            ]
        case .detail(let id):
            return baseItems + [.init(name: "id", value: id)]
        }
    }
}
