//
//  APIService.swift
//  appdb-v2
//
//  Created by ned on 08/01/23.
//

import Foundation
import Networking

open class APIService {
    let urlSession: URLSession
    let decoder: JSONDecoder
    
    init(urlSession: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.urlSession = urlSession
        self.decoder = decoder
    }

    open func request<T: Decodable>(_ endpoint: Endpoint, _ method: API.Method = .GET) async throws -> T {
        let request = API.generateRequest(endpoint, method: method)
        let (data, _) = try await urlSession.data(for: request)
        return try decoder.decode(T.self, from: data)
    }
}
