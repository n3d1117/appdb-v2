//
//  APITests.swift
//
//
//  Created by ned on 07/01/23.
//

import XCTest
@testable import Networking

final class APITests: XCTestCase {
    
    // MARK: - HTTP Method
    func testHTTPRequestMethodIsCorrect() throws {
        let newsListEndpoint = Endpoint.news(.list())
        
        var request = API.generateRequest(newsListEndpoint)
        XCTAssertEqual(request.httpMethod, "GET")
        
        request = API.generateRequest(newsListEndpoint, method: .POST)
        XCTAssertEqual(request.httpMethod, "POST")
        
        request = API.generateRequest(newsListEndpoint, method: .PUT)
        XCTAssertEqual(request.httpMethod, "PUT")
        
        request = API.generateRequest(newsListEndpoint, method: .DELETE)
        XCTAssertEqual(request.httpMethod, "DELETE")
        
        request = API.generateRequest(newsListEndpoint, method: .PATCH)
        XCTAssertEqual(request.httpMethod, "PATCH")
    }
}
