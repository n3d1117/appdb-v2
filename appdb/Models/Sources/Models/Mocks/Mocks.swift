//
//  Mocks.swift
//  
//
//  Created by ned on 10/01/23.
//

import Foundation

extension URL {
    static let exampleImage: Self = .init(string: "https://is2-ssl.mzstatic.com/image/thumb/Purple113/v4/40/3f/c5/403fc5f0-7622-1171-5127-fae1666d3a84/AppIcon-0-0-1x_U007emarketing-0-0-0-7-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/100x100bb.jpg")!
}

public extension Genre {
    static let mock: Self = .init(id: "1", name: "Example")
}

public extension App {
    static let mock: Self = .init(
        id: UUID().uuidString,
        name: "Example",
        image: .exampleImage,
        genreId: Genre.mock.id,
        gname: Genre.mock.name
    )
}

public extension NewsEntry {
    static let mock: Self = .init(id: UUID().uuidString, title: "Example news")
}

public extension APIError {
    static let example: Self = .init(code: "Example code", translated: "Example translation")
}
