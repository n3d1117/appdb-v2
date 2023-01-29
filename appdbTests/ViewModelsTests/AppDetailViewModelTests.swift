//
//  AppDetailViewModelTests.swift
//  appdbTests
//
//  Created by ned on 10/01/23.
//

import XCTest
import Models
@testable import appdb

@MainActor final class AppDetailViewModelTests: XCTestCase {
    
    override class func setUp() {
        Dependencies.screenshotsCache.register { .mock }
        Dependencies.imageSizeFetcher.register { .mock(returning: .init(width: 180, height: 320)) }
    }

    func testAppLoading() async throws {
        let app: App = .mock
        Dependencies.apiService.register {
            .mock(.data([app]))
        }
        let viewModel = AppDetailView.ViewModel(id: app.id)
        XCTAssertEqual(viewModel.state, .loading)
        
        await viewModel.loadAppDetails()
        
        XCTAssertEqual(viewModel.state, .success(app))
    }
    
    func testAppsRequestSuccessButEmptyData() async throws {
        let mockEmptyResponse: [App] = []
        Dependencies.apiService.register {
            .mock(.data(mockEmptyResponse))
        }
        let viewModel = AppDetailView.ViewModel(id: App.mock.id)
        XCTAssertEqual(viewModel.state, .loading)
        
        await viewModel.loadAppDetails()
        
        XCTAssertEqual(viewModel.state, .failed(APIError.missingData))
    }
    
    func testAppsLoadingFail() async throws {
        let apiError: APIError = .example
        Dependencies.apiService.register {
            .mock(.error(apiError))
        }
        let viewModel = AppDetailView.ViewModel(id: App.mock.id)
        XCTAssertEqual(viewModel.state, .loading)
        
        await viewModel.loadAppDetails()
        
        XCTAssertEqual(viewModel.state, .failed(
            APIError(code: apiError.code, translated: apiError.translated)
        ))
    }

}
