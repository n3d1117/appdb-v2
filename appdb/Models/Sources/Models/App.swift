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
    public let version: String
    public let clicksMonth: Int
    public let description: String
    public let whatsnew: String?
    public let compatibilityString: String
    
    private let gname: String
    private let genreId: String
    private let lastParseItunes: LastParseItunes?
    
    public var genre: Genre { .init(id: genreId, name: gname) }
    public var publisher: String? { lastParseItunes?.publisher }
    public var lastUpdated: Date? { lastParseItunes?.published }
    public var censorRating: String? { lastParseItunes?.censorRating.components(separatedBy: " ").dropFirst().first }
    public var languages: [String]? { lastParseItunes?.languages.components(separatedBy: ", ") }
    public var ratings: (count: Int, stars: Double)? {
        guard let ratings = lastParseItunes?.ratings else { return nil }
        return (ratings.count, ratings.stars)
    }
    public var size: (size: Double, unit: String)? {
        if let separatedSize = lastParseItunes?.size.components(separatedBy: " ") {
            return (Double(separatedSize.first ?? "") ?? .zero, separatedSize.dropFirst().first ?? "MB")
        }
        return nil
    }
    public var screenshotsUrls: [URL] {
        var urls: [URL] = lastParseItunes?.screenshots.iphone.map(\.src) ?? []
        if urls.isEmpty { urls = lastParseItunes?.screenshots.ipad.map(\.src) ?? [] }
        return urls
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name).htmlDecoded
        self.image = try container.decode(URL.self, forKey: .image)
        self.version = try container.decode(String.self, forKey: .version)
        self.clicksMonth = try Int(container.decode(String.self, forKey: .clicksMonth)) ?? .zero
        self.description = try container.decode(String.self, forKey: .description).htmlDecoded
        self.whatsnew = try container.decodeIfPresent(String.self, forKey: .whatsnew)?.htmlDecoded
        self.gname = try container.decode(String.self, forKey: .gname)
        self.genreId = try container.decode(String.self, forKey: .genreId)
        self.compatibilityString = try container.decode(String.self, forKey: .compatibilityString)
        
        do {
            if let lastParseItunesString = try container.decodeIfPresent(String.self, forKey: .lastParseItunes) {
                let lastParseItunesData = lastParseItunesString.data(using: .utf8) ?? .init()
                self.lastParseItunes = try JSONDecoder.convertFromSnakeCase.decode(LastParseItunes.self, from: lastParseItunesData)
            } else {
                self.lastParseItunes = nil
            }
        } catch {
            self.lastParseItunes = nil
        }
    }
    
    public init(
        id: String,
        name: String,
        image: URL,
        version: String,
        clicksMonth: Int,
        description: String,
        whatsnew: String,
        gname: String,
        genreId: String,
        compatibilityString: String,
        lastParseItunes: LastParseItunes
    ) {
        self.id = id
        self.name = name
        self.image = image
        self.version = version
        self.clicksMonth = clicksMonth
        self.description = description
        self.whatsnew = whatsnew
        self.gname = gname
        self.genreId = genreId
        self.compatibilityString = compatibilityString
        self.lastParseItunes = lastParseItunes
    }
}

public struct LastParseItunes: Codable, Equatable {
    public let ratings: CustomerRating?
    public let censorRating: String
    public let published: Date
    public let publisher: String
    public let size: String
    public let languages: String
    public let screenshots: Screenshots
    
    public init(ratings: CustomerRating?, censorRating: String, published: Date, publisher: String, size: String, languages: String, screenshots: Screenshots) {
        self.ratings = ratings
        self.censorRating = censorRating
        self.published = published
        self.publisher = publisher
        self.size = size
        self.languages = languages
        self.screenshots = screenshots
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.ratings = try container.decodeIfPresent(CustomerRating.self, forKey: .ratings)
        self.censorRating = try container.decode(String.self, forKey: .censorRating)
        self.publisher = try container.decode(String.self, forKey: .publisher)
        self.size = try container.decode(String.self, forKey: .size)
        self.languages = try container.decode(String.self, forKey: .languages)
        self.screenshots = try container.decodeIfPresent(Screenshots.self, forKey: .screenshots) ?? .empty
        
        let publishedString = try container.decode(String.self, forKey: .published)
        if let date = DateFormatter.ddMMyyyy.date(from: publishedString) {
            self.published = date
        } else {
            throw DecodingError.dataCorruptedError(
                forKey: .published,
                in: container,
                debugDescription: "Date string does not match format expected by formatter."
            )
        }
    }
}

extension DateFormatter {
    static let ddMMyyyy: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
}

extension JSONDecoder {
    static let convertFromSnakeCase: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}

public struct Screenshots: Codable, Equatable {
    public struct Screenshot: Codable, Equatable {
        public let src: URL
    }
    
    public let iphone: [Screenshot]
    public let ipad: [Screenshot]
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.iphone = try container.decodeIfPresent([Screenshot].self, forKey: .iphone) ?? []
        self.ipad = try container.decodeIfPresent([Screenshot].self, forKey: .ipad) ?? []
    }
    
    init(iphone: [Screenshot], ipad: [Screenshot]) {
        self.iphone = iphone
        self.ipad = ipad
    }
    
    static let empty: Self = .init(iphone: [], ipad: [])
}

public struct CustomerRating: Codable, Equatable {
    public let count: Int
    public let stars: Double
}

public struct Genre: Codable, Equatable {
    public let id: String
    public let name: String
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
