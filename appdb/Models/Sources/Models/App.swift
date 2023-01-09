//
//  App.swift
//  
//
//  Created by ned on 09/01/23.
//

import Foundation

public struct App: Codable, Identifiable {
    public let id: String
    public let name: String
    public let image: URL
    
    public init(id: String, name: String, image: URL) {
        self.id = id
        self.name = name
        self.image = image
    }
}

extension App: Equatable {
    public static func ==(lhs: App, rhs: App) -> Bool {
        return lhs.id == rhs.id
    }
}

extension App: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
