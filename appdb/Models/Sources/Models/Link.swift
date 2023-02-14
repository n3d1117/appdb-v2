//
//  File.swift
//  
//
//  Created by ned on 14/02/23.
//

import Foundation

// MARK: - LinksResponse
public struct LinksResponse: Codable {
    public struct App: Codable {
        let trackid: String
        let versions: [Version]
    }
    
    public struct Version: Codable, Identifiable {
        public let number: String
        public let links: [Link]
        
        public var id: String { number }
    }
    
    private let apps: [App]
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let response = try container.decode([String: [String: [Link]]].self)
        self.apps = response.map { trackid, versions in
            App(trackid: trackid, versions: versions.map { number, links in
                Version(number: number, links: links)
            }.sorted(by: { (v1, v2) -> Bool in
                v1.number.compare(v2.number, options: .numeric) == .orderedDescending
            }))
        }
    }
    
    public init(apps: [App]) {
        self.apps = apps
    }
    
    public func versions(for trackid: String) -> [Version] {
        apps.first(where: { $0.trackid == trackid })?.versions ?? []
    }
}

extension [LinksResponse.Version]: Identifiable {
    public var id: Self { self }
}

extension LinksResponse.Version: Equatable {
    public static func ==(lhs: LinksResponse.Version, rhs: LinksResponse.Version) -> Bool {
        return lhs.number == rhs.number
    }
}

extension LinksResponse.Version: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(number)
    }
}

// MARK: - Link
public struct Link: Codable, Identifiable {
    public let id: String
    public let host: String
    
    public init(id: String, host: String) {
        self.id = id
        self.host = host
    }
}

extension Link: Equatable {
    public static func ==(lhs: Link, rhs: Link) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Link: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
