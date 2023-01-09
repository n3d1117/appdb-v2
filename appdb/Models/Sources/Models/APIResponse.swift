//
//  APIResponse.swift
//  
//
//  Created by ned on 09/01/23.
//

import Foundation

public struct APIResponse<T: Codable>: Codable {
    public let success: Bool
    public let errors: [APIError]
    public let data: T
    public let total: String?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decode(Bool.self, forKey: .success)
        self.errors = try container.decode([APIError].self, forKey: .errors)
        self.data = try container.decode(T.self, forKey: .data)
        // `total` can either be an Int or a String...
        if let totalAsInteger = try? container.decodeIfPresent(Int.self, forKey: .total) {
            self.total = String(describing: totalAsInteger)
        } else {
            self.total = try container.decodeIfPresent(String.self, forKey: .total)
        }
    }
    
    public init(success: Bool, errors: [APIError], data: T, total: String?) {
        self.success = success
        self.errors = errors
        self.data = data
        self.total = total
    }
    
    public init(_ data: T) {
        self.success = true
        self.errors = []
        self.data = data
        self.total = nil
    }
}

public struct APIError: Codable {
    public let code: String
    public let translated: String
    
    public init(code: String, translated: String) {
        self.code = code
        self.translated = translated
    }
    
    public static let example: Self = .init(code: "Example code", translated: "Example translation")
}

extension APIError: LocalizedError {
    public var errorDescription: String? { translated }
}
