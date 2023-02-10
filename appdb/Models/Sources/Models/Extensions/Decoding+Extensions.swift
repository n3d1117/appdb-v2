//
//  Decoding+Extensions.swift
//  
//
//  Created by ned on 10/02/23.
//

import Foundation

extension KeyedDecodingContainer {
    
    /// Decodes a Unix timestamp represented as a string into a `Date` object.
    /// - Parameter key: The key to look for in the container.
    /// - Returns: A `Date` object, if the timestamp was successfully decoded. `nil` otherwise.
    /// - Throws: Any errors thrown while decoding the timestamp string.
    func decodeUnixDate(forKey key: Key) throws -> Date? {
        if let dateString = try decodeIfPresent(String.self, forKey: key),
           let asDouble = Double(dateString) {
            return Date(timeIntervalSince1970: asDouble)
        }
        return nil
    }
    
    /// Decodes a dd.MM.yyyy date represented as a string into a `Date` object.
    /// - Parameter key: The key to look for in the container.
    /// - Returns: A `Date` object, if the successfully decoded. `nil` otherwise.
    /// - Throws: Any errors thrown while decoding the date string.
    func decodeDDMMYYYYDate(forKey key: Key) throws -> Date? {
        if let dateString = try decodeIfPresent(String.self, forKey: key),
           let date = DateFormatter.ddMMyyyy.date(from: dateString) {
            return date
        }
        return nil
    }
    
    /// Decodes a JSON string into an instance of the specified type.
    /// - Parameter type: The type to decode the JSON string into.
    /// - Parameter key: The key to look for in the container.
    /// - Returns: An instance of the specified type, if the JSON string was successfully decoded. `nil` otherwise.
    /// - Throws: Any errors thrown while decoding the JSON string.
    func decodeJSON<T: Decodable>(_ type: T.Type, forKey key: Key) throws -> T? {
        if let stringData = try decodeIfPresent(String.self, forKey: key) {
            let data = stringData.data(using: .utf8) ?? .init()
            return try JSONDecoder.convertFromSnakeCase.decode(type, from: data)
        } else {
            return nil
        }
    }
}


private extension DateFormatter {
    static let ddMMyyyy: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
}

private extension JSONDecoder {
    static let convertFromSnakeCase: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}
