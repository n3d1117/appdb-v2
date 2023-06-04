//
//  API.swift
//  
//
//  Created by ned on 07/01/23.
//

import Foundation

public enum API {
    public static let apiURL = "api.dbservices.to"
    public static let apiVersion: String = "1.6"

    public enum Method: String {
        case GET, POST, PUT, PATCH, DELETE
    }
    
    private static func generateURL(endpoint: Endpoint) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Self.apiURL
        components.path += "/v\(Self.apiVersion)/\(endpoint.path)/"
        components.queryItems = endpoint.queryItems
        return components.url!
    }

    public static func generateRequest(_ endpoint: Endpoint, method: Method = .GET) -> URLRequest {
        var request = URLRequest(url: generateURL(endpoint: endpoint))
        request.httpMethod = method.rawValue
        request.addValue("appdb iOS Client v2", forHTTPHeaderField: "User-Agent")
        return request
    }
}
