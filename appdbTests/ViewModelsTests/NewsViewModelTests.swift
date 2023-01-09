//
//  NewsViewModelTests.swift
//  appdbTests
//
//  Created by ned on 09/01/23.
//

import XCTest
import Models
@testable import appdb

@MainActor final class NewsViewModelTests: XCTestCase {

    func testNewsLoading() async throws {
        Dependencies.apiService.register {
            .mock(.data([NewsEntry(id: "1", title: "One")]))
        }
        let viewModel = NewsView.ViewModel()
        XCTAssertTrue(viewModel.state == .loading)
        
        await viewModel.loadNews()
        
        XCTAssertEqual(viewModel.state, .success([NewsEntry(id: "1", title: "One")]))
    }
    
    func testNewsLoadingFail() async throws {
        let apiError: APIError = .example
        Dependencies.apiService.register {
            .mock(.error(apiError))
        }
        let viewModel = NewsView.ViewModel()
        XCTAssertTrue(viewModel.state == .loading)
        
        await viewModel.loadNews()
        
        XCTAssertEqual(viewModel.state, .failed(
            APIError(code: apiError.code, translated: apiError.translated)
        ))
    }

}
