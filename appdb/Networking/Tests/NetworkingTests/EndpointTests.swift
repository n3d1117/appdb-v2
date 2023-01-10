//
//  EndpointTests.swift
//  
//
//  Created by ned on 09/01/23.
//

import XCTest
@testable import Networking

final class EndpointTests: XCTestCase {
    
    static let urlPath: String = "https://\(API.apiURL)/v\(API.apiVersion)"
    
    // MARK: - Apps
    func testAppsListEndpointGeneratedURLIsCorrect() throws {
        let request = API.generateRequest(.apps(.list(type: .ios)))
        let url = try XCTUnwrap(request.url)
        XCTAssertEqual(url.absoluteString, "\(Self.urlPath)/?action=search&type=ios&page=1")
    }
    
    func testAppsListEndpointGeneratedURLAndPageIsCorrect() throws {
        let request = API.generateRequest(.apps(.list(type: .ios, page: 2)))
        let url = try XCTUnwrap(request.url)
        XCTAssertEqual(url.absoluteString, "\(Self.urlPath)/?action=search&type=ios&page=2")
    }
    
    // MARK: - News
    func testNewsListEndpointGeneratedURLIsCorrect() throws {
        let request = API.generateRequest(.news(.list(limit: 50)))
        let url = try XCTUnwrap(request.url)
        XCTAssertEqual(url.absoluteString, "\(Self.urlPath)/?action=get_pages&category=news&length=50")
    }
    
    func testNewsDetailEndpointGeneratedURLIsCorrect() throws {
        let request = API.generateRequest(.news(.detail(id: "469")))
        let url = try XCTUnwrap(request.url)
        XCTAssertEqual(url.absoluteString, "\(Self.urlPath)/?action=get_pages&category=news&id=469")
    }
}
