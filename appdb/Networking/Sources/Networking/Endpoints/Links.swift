//
//  Links.swift
//  
//
//  Created by ned on 14/02/23.
//

import Foundation

public enum Links: HTTPEndpoint {
    case get(type: AppType, trackid: Int)
    
    var path: String { "get_links" }
    
    public var queryItems: [URLQueryItem] {
        switch self {
        case .get(let type, let trackid):
            return [
                .init(name: "type", value: type.rawValue),
                .init(name: "trackids", value: String(trackid)),
            ]
        }
    }
}
