//
//  App.swift
//  
//
//  Created by ned on 09/01/23.
//

import Foundation

public struct App: Codable, Identifiable {
    
    // MARK: - Public
    public let id: String
    public let name: String
    public let image: URL?
    public let version: String
    public let clicksMonth: Int
    public let description: String?
    public let whatsnew: String?
    public let compatibilityString: String
    public let tweakedVersions: TweakedVersions?
    public let is18Plus: Bool
    
    // MARK: - Private
    private let gname: String
    private let pname: String?
    private let genreId: String
    private let lastParseItunes: LastParseItunes?
    private let screenshots: Screenshots?
    private let added: Date?
    private let originalTrackid: String?
    private let originalSection: String?
    private let pwebsite: URL?
    private let psupport: URL?
    
    // MARK: - Computed vars
    public var genre: Genre { .init(id: genreId, name: gname) }
    public var publisher: String? { lastParseItunes?.publisher ?? pname?.trimmingCharacters(in: .whitespacesAndNewlines) }
    public var lastUpdated: Date? { lastParseItunes?.published ?? added }
    public var censorRating: String? { lastParseItunes?.censorRating.components(separatedBy: " ").dropFirst().first }
    public var languages: [String]? { lastParseItunes?.languages.components(separatedBy: ", ") }
    public var isTweaked: Bool { originalTrackid != nil && originalTrackid != "0" }
    public var website: URL? { pwebsite ?? psupport }
    public var ratings: (count: Int, stars: Double)? {
        guard let ratings = lastParseItunes?.ratings else { return nil }
        return (ratings.count, ratings.stars)
    }
    public var size: (size: Double, unit: String)? {
        guard let separatedSize = lastParseItunes?.size.components(separatedBy: " ") else { return nil }
        return (Double(separatedSize.first ?? "") ?? .zero, separatedSize.dropFirst().first ?? "MB")
    }
    public var screenshotsUrls: [URL] {
        guard let screenshots = lastParseItunes?.screenshots ?? screenshots else { return [] }
        var urls: [URL] = screenshots.iphone.map(\.src)
        if urls.isEmpty { urls = screenshots.ipad.map(\.src) }
        return urls
    }
    public var originalApp: (trackid: String, section: String)? {
        guard isTweaked, let originalTrackid, let originalSection else { return nil }
        return (trackid: originalTrackid, section: originalSection)
    }
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case id, name, image, version, description, whatsnew, gname, pname, screenshots, added, pwebsite, psupport
        case clicksMonth = "clicks_month"
        case compatibilityString = "compatibility_string"
        case tweakedVersions = "tweaked_versions"
        case is18Plus = "is_18plus"
        case genreId = "genre_id"
        case lastParseItunes = "last_parse_itunes"
        case originalTrackid = "original_trackid"
        case originalSection = "original_section"
    }
    
    // MARK: - Decoding
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name).htmlToMarkdown
        self.image = try container.decodeIfPresent(URL.self, forKey: .image)
        self.version = try container.decode(String.self, forKey: .version)
        self.clicksMonth = try Int(container.decode(String.self, forKey: .clicksMonth)) ?? .zero
        self.description = try container.decodeIfPresent(String.self, forKey: .description)?.htmlToMarkdown
        self.whatsnew = try container.decodeIfPresent(String.self, forKey: .whatsnew)?.htmlToMarkdown
        self.gname = try container.decode(String.self, forKey: .gname)
        self.pname = try container.decodeIfPresent(String.self, forKey: .pname)
        self.genreId = try container.decode(String.self, forKey: .genreId)
        self.compatibilityString = try container.decode(String.self, forKey: .compatibilityString)
        self.tweakedVersions = try container.decodeIfPresent(TweakedVersions.self, forKey: .tweakedVersions)
        self.originalTrackid = try container.decodeIfPresent(String.self, forKey: .originalTrackid)
        self.originalSection = try container.decodeIfPresent(String.self, forKey: .originalSection)
        self.is18Plus = (try? container.decodeIfPresent(String.self, forKey: .is18Plus) ?? "") == "1"
        self.pwebsite = try? container.decodeIfPresent(URL.self, forKey: .pwebsite)
        self.psupport = try? container.decodeIfPresent(URL.self, forKey: .psupport)
        self.added = try? container.decodeUnixDate(forKey: .added)
        self.screenshots = try? container.decodeJSON(Screenshots.self, forKey: .screenshots)
        self.lastParseItunes = try? container.decodeJSON(LastParseItunes.self, forKey: .lastParseItunes)
    }
    
    // MARK: - Initializer
    public init(
        id: String,
        name: String,
        image: URL,
        version: String,
        clicksMonth: Int,
        description: String,
        whatsnew: String,
        gname: String,
        pname: String?,
        genreId: String,
        compatibilityString: String,
        added: Date?,
        originalTrackid: String?,
        originalSection: String?,
        pWebsite: URL?,
        pSupport: URL?,
        tweakedVersions: TweakedVersions?,
        screenshots: Screenshots?,
        lastParseItunes: LastParseItunes?,
        is18Plus: Bool
    ) {
        self.id = id
        self.name = name
        self.image = image
        self.version = version
        self.clicksMonth = clicksMonth
        self.description = description
        self.whatsnew = whatsnew
        self.gname = gname
        self.pname = pname
        self.genreId = genreId
        self.compatibilityString = compatibilityString
        self.added = added
        self.originalTrackid = originalTrackid
        self.originalSection = originalSection
        self.pwebsite = pWebsite
        self.psupport = pSupport
        self.tweakedVersions = tweakedVersions
        self.screenshots = screenshots
        self.lastParseItunes = lastParseItunes
        self.is18Plus = is18Plus
    }
}

// MARK: - LastParseItunes struct
public struct LastParseItunes: Codable, Equatable {
    public let ratings: CustomerRating?
    public let censorRating: String
    public let published: Date?
    public let publisher: String
    public let size: String
    public let languages: String
    public let screenshots: App.Screenshots
    
    public init(ratings: CustomerRating?, censorRating: String, published: Date, publisher: String, size: String, languages: String, screenshots: App.Screenshots) {
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
        self.screenshots = try container.decodeIfPresent(App.Screenshots.self, forKey: .screenshots) ?? .empty
        self.published = try container.decodeDDMMYYYYDate(forKey: .published)
    }
    
    // MARK: - CustomerRating struct
    public struct CustomerRating: Codable, Equatable {
        public let count: Int
        public let stars: Double
    }
}

// MARK: - Screenshots struct
extension App {
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
}

// MARK: - Genre struct
extension App {
    public struct Genre: Codable, Equatable {
        public let id: String
        public let name: String
    }
}

// MARK: - TweakedVersions struct
extension App {
    public struct TweakedVersions: Codable, Equatable {
        public let cydia: [TweakedVersion]
        
        public struct TweakedVersion: Codable, Equatable {
            public let trackid: String
        }
    }
}

// MARK: - Protocol Conformances
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
