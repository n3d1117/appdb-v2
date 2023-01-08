//
//  API.swift
//  
//
//  Created by ned on 07/01/23.
//

import Foundation

public enum API {
    public static let apiURL = "api.dbservices.to"
    public static let apiVersion: String = "1.5"

    public enum Method: String {
        case GET, POST, PUT, PATCH, DELETE
    }
    
    private static func generateURL(scheme: String = "https", endpoint: Endpoint) -> URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = Self.apiURL
        components.path += "/v\(Self.apiVersion)/"
        components.queryItems = endpoint.queryItems()
        return components.url!
    }

    public static func generateRequest(_ endpoint: Endpoint, method: Method = .GET) -> URLRequest {
        var request = URLRequest(url: generateURL(endpoint: endpoint))
        request.httpMethod = method.rawValue
        request.addValue("appdb iOS Client v2", forHTTPHeaderField: "User-Agent")
        return request
    }
}
