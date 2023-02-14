//
//  Links.swift
//  
//
//  Created by ned on 14/02/23.
//

import Foundation

public enum Links: HTTPEndpoint {
    case get(type: AppType, trackid: String)
    
    public func queryItems() -> [URLQueryItem]? {
        switch self {
        case .get(let type, let trackid):
            return [
                .init(name: "action", value: "get_links"),
                .init(name: "type", value: type.rawValue),
                .init(name: "trackids", value: trackid),
            ]
        }
    }
}
