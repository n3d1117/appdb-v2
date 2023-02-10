//
//  APIService.swift
//  appdb
//
//  Created by ned on 08/01/23.
//

import Foundation
import Networking
import Models

protocol Networking {
    /// Retrieve data for the given request
    ///
    /// - Parameters:
    ///   - request: The request to send
    /// - Returns: A tuple containing the data and the URL response
    /// - Throws: An error if something goes wrong
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: Networking {}

class APIService {
    let networking: Networking
    let decoder: JSONDecoder
    
    /// Initialize an APIService instance
    ///
    /// - Parameters:
    ///   - networking: An instance that conforms to the Networking protocol, used to fetch data for requests. Defaults to `URLSession.shared`.
    ///   - decoder: An instance of `JSONDecoder`, used to decode data into codable models. Defaults to a new instance of `JSONDecoder`.
    init(networking: Networking = URLSession.shared, decoder: JSONDecoder = .init()) {
        self.networking = networking
        self.decoder = decoder
    }

    /// Send a request to an API endpoint and decode the response
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint to send the request to
    ///   - method: The HTTP method to use for the request. Defaults to `.GET`.
    /// - Returns: The decoded response from the API
    /// - Throws: An error if something goes wrong or if the `errors` array from the response is not empty
    func request<T: Codable>(_ endpoint: Endpoint, _ method: API.Method = .GET) async throws -> APIResponse<T> {
        let request = API.generateRequest(endpoint, method: method)
        let (data, _) = try await networking.data(for: request)
        let response = try decoder.decode(APIResponse<T>.self, from: data)
        if let firstError = response.errors.first { throw firstError }
        return response
    }
}

#if DEBUG
extension APIService {
    private class APIServiceMock<T: Codable>: APIService {
        let mockType: MockType<T>
        
        init(_ mockType: MockType<T>) {
            self.mockType = mockType
        }
        
        override func request<T>(_ endpoint: Endpoint, _ method: API.Method = .GET) async throws -> APIResponse<T> {
            switch mockType {
            case .loading:
                try? await Task.sleep(for: .seconds(999))
                throw APIError.example
            case .data(let codableData):
                return .init(codableData as! T)
            case .error(let error, _):
                throw error
            }
        }
    }
    
    enum MockType<T: Codable> {
        case data(T)
        case error(APIError, T.Type = String.self)
        case loading(T.Type = String.self)
    }
    
    static func mock<T: Codable>(_ mock: MockType<T>) -> APIService {
        APIServiceMock<T>(mock)
    }
}
#endif
