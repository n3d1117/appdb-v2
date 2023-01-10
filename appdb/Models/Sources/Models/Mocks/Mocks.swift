//
//  Mocks.swift
//  
//
//  Created by ned on 10/01/23.
//

import Foundation

public extension App {
    static let mock: Self = .init(id: UUID().uuidString, name: "Example", image: .init(string: "https://edoardo.fyi/me.jpeg")!)
}

public extension NewsEntry {
    static let mock: Self = .init(id: UUID().uuidString, title: "Example news")
}

public extension APIError {
    static let example: Self = .init(code: "Example code", translated: "Example translation")
}
