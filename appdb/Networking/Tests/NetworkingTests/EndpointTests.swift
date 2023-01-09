//
//  EndpointTests.swift
//  
//
//  Created by ned on 09/01/23.
//

import XCTest
@testable import Networking

final class EndpointTests: XCTestCase {
    
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
