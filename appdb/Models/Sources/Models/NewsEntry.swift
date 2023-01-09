//
//  NewsEntry.swift
//  
//
//  Created by ned on 08/01/23.
//

public struct NewsEntry: Codable, Identifiable {
    public let id: String
    public let title: String
    
    public init(id: String, title: String) {
        self.id = id
        self.title = title
    }
}

extension NewsEntry: Equatable {
    public static func ==(lhs: NewsEntry, rhs: NewsEntry) -> Bool {
        return lhs.id == rhs.id
    }
}

extension NewsEntry: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
