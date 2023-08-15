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
        XCTAssertEqual(url.absoluteString, "\(Self.urlPath)/search/?type=ios&start=0&length=25")
    }
    
    func testAppsListEndpointGeneratedURLAndPageIsCorrect() throws {
        let request = API.generateRequest(.apps(.list(type: .ios, page: 2)))
        let url = try XCTUnwrap(request.url)
        XCTAssertEqual(url.absoluteString, "\(Self.urlPath)/search/?type=ios&start=25&length=25")
    }
    
    func testAppsDetailEndpointGeneratedURLIsCorrect() throws {
        let request = API.generateRequest(.apps(.detail(type: .ios, trackid: 1)))
        let url = try XCTUnwrap(request.url)
        XCTAssertEqual(url.absoluteString, "\(Self.urlPath)/search/?type=ios&trackid=1")
    }
    
    // MARK: - News
    func testNewsListEndpointGeneratedURLIsCorrect() throws {
        let request = API.generateRequest(.news(.list(length: 50, page: 2)))
        let url = try XCTUnwrap(request.url)
        XCTAssertEqual(url.absoluteString, "\(Self.urlPath)/get_pages/?category=news&start=50&length=50")
    }
    
    func testNewsDetailEndpointGeneratedURLIsCorrect() throws {
        let request = API.generateRequest(.news(.detail(id: "469")))
        let url = try XCTUnwrap(request.url)
        XCTAssertEqual(url.absoluteString, "\(Self.urlPath)/get_pages/?category=news&id=469")
    }
    
    // MARK: - Links
    func testLinksEndpointGeneratedURLIsCorrect() throws {
        let request = API.generateRequest(.links(.get(type: .ios, trackid: 1)))
        let url = try XCTUnwrap(request.url)
        XCTAssertEqual(url.absoluteString, "\(Self.urlPath)/get_links/?type=ios&trackids=1")
    }
}
