//
//  AppsViewModelTests.swift
//  appdbTests
//
//  Created by ned on 09/01/23.
//

import XCTest
import Models
@testable import appdb

@MainActor final class AppsViewModelTests: XCTestCase {

    func testAppsLoading() async throws {
        let app: App = .mock
        Dependencies.apiService.register {
            .mock(.data([app]))
        }
        let viewModel = AppsView.ViewModel()
        XCTAssertEqual(viewModel.state, .loading)
        
        await viewModel.loadApps()
        
        XCTAssertEqual(viewModel.state, .success([app]))
    }
    
    func testAppsLoadingFail() async throws {
        let apiError: APIError = .example
        Dependencies.apiService.register {
            .mock(.error(apiError))
        }
        let viewModel = AppsView.ViewModel()
        XCTAssertEqual(viewModel.state, .loading)
        
        await viewModel.loadApps()
        
        XCTAssertEqual(viewModel.state, .failed(
            APIError(code: apiError.code, translated: apiError.translated)
        ))
    }

}
