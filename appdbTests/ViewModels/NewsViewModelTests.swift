//
//  NewsViewModelTests.swift
//  appdbTests
//
//  Created by ned on 09/01/23.
//

import XCTest
import Models
@testable import appdb_v2

@MainActor final class NewsViewModelTests: XCTestCase {

    func testNewsLoading() async throws {
        Dependencies.apiService.register {
            .mock(NewsList(data: [.init(id: "1", title: "One")]))
        }
        let viewModel = NewsView.ViewModel()
        XCTAssertTrue(viewModel.state == .loading)
        
        await viewModel.loadNews()
        
        XCTAssertEqual(viewModel.state, .success([.init(id: "1", title: "One")]))
    }

}
