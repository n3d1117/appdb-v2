//
//  APITests.swift
//
//
//  Created by ned on 07/01/23.
//

import XCTest
import Combine
@testable import Networking

final class APITests: XCTestCase {
    
    func testHTTPRequestMethodIsCorrect() throws {
        let newsListEndpoint = Endpoint.news(.list(limit: 10))
        
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
    
    // MARK: - News
    func testNewsListEndpointGeneratedURLIsCorrect() throws {
        let request = API.generateRequest(.news(.list(limit: 50)))
        let url = try XCTUnwrap(request.url)
        XCTAssertEqual(url.absoluteString, "https://\(API.apiURL)/v\(API.apiVersion)/?action=get_pages&category=news&length=50")
    }
    
    func testNewsDetailEndpointGeneratedURLIsCorrect() throws {
        let request = API.generateRequest(.news(.detail(id: "469")))
        let url = try XCTUnwrap(request.url)
        XCTAssertEqual(url.absoluteString, "https://\(API.apiURL)/v\(API.apiVersion)/?action=get_pages&category=news&id=469")
    }
}
