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

public extension App.Genre {
    static let mock: Self = .init(id: 1, name: "Example")
}

public extension App {
    static let mock: Self = .init(
        id: Int.random(in: 0...129999),
        name: "Example",
        image: .exampleImage,
        version: "1.0",
        description: "Example app description",
        whatsnew: "Example what's new",
        gname: Genre.mock.name,
        pname: nil,
        genreId: Genre.mock.id,
        compatibilityString: "Compatible with iPhone, iPad, iPod. Requires iOS 11.0 or newer",
        added: nil,
        originalTrackid: nil,
        originalSection: nil,
        pWebsite: nil,
        pSupport: nil,
        tweakedVersions: nil,
        screenshots: nil,
        lastParseItunes: .init(
            ratings: .init(count: 12, stars: 4.5),
            censorRating: "Rated 12+",
            published: .now.addingTimeInterval(-15000),
            publisher: "TikTok Ltd.",
            size: "395.46 MB",
            languages: "EN, IT",
            screenshots: .init(iphone: [.init(src: .init(string: "https://is5-ssl.mzstatic.com/image/thumb/Purple112/v4/31/9d/63/319d63fe-14dd-bfcf-2808-b201c3e934df/286d4143-8b62-46e7-926e-2f7595c165f6_en-GB__screenshots__iOS-5.5-in__01.jpg/392x696bb.jpg")!), .init(src: .init(string: "https://is5-ssl.mzstatic.com/image/thumb/Purple112/v4/31/9d/63/319d63fe-14dd-bfcf-2808-b201c3e934df/286d4143-8b62-46e7-926e-2f7595c165f6_en-GB__screenshots__iOS-5.5-in__01.jpg/392x696bb.jpg")!), .init(src: .init(string: "https://is5-ssl.mzstatic.com/image/thumb/Purple112/v4/31/9d/63/319d63fe-14dd-bfcf-2808-b201c3e934df/286d4143-8b62-46e7-926e-2f7595c165f6_en-GB__screenshots__iOS-5.5-in__01.jpg/392x696bb.jpg")!)], ipad: [])
        ),
        is18Plus: false,
        bundleId: "some.bundle.id",
        price: "Free",
        clicksToday: 5,
        clicksWeek: 50,
        clicksMonth: 100,
        clicksYear: 150,
        clicksTotal: 200
    )
}

public extension NewsEntry {
    static let mock: Self = .init(id: 1, title: "Example news")
}

public extension LinksResponse {
    static let mock: Self = .init(apps: [
        .init(trackid: Models.App.mock.id, versions: [
            .init(number: "1.1", links: [
                .init(id: 1, host: "example.com")
            ]),
            .init(number: "1.0", links: [
                .init(id: 2, host: "another.example.com")
            ])
        ])
    ])
}

public extension APIError {
    static let example: Self = .init(code: "Example code", translated: "Example translation")
}
