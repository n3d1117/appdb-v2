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
