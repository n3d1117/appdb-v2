//
//  APIError.swift
//  
//
//  Created by ned on 03/02/23.
//

import Foundation

public struct APIError: Codable {
    public let code: String
    public let translated: String
    
    public init(code: String, translated: String) {
        self.code = code
        self.translated = translated
    }
}

extension APIError: LocalizedError {
    public var errorDescription: String? { translated }
}

public extension APIError {
    static let missingData: Self = .init(code: "MISSING_DATA", translated: "Some data is missing")
}
