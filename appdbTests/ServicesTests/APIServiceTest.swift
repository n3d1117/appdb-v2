//
//  APIServiceTest.swift
//  appdbTests
//
//  Created by ned on 09/01/23.
//

import XCTest
import Models
@testable import appdb

@MainActor final class APIServiceTests: XCTestCase {

    class NetworkingMock: Networking {
        let mockedData: Data
        
        init(mockedData: Data) {
            self.mockedData = mockedData
        }

        func data(for request: URLRequest) async throws -> (Data, URLResponse) {
            (mockedData, .init())
        }
    }
    
    func testApiServiceReturnsTheCorrectResponse() async throws {
        let apiResponse: APIResponse<[NewsEntry]> = .init([NewsEntry(id: "1", title: "One")])
        let data = try JSONEncoder().encode(apiResponse)
        let apiService = APIService(networking: NetworkingMock(mockedData: data))
        
        let response: APIResponse<[NewsEntry]> = try await apiService.request(.news(.list(limit: 1)))
        XCTAssertEqual(response.data, apiResponse.data)
    }
    
    func testApiServiceThrowsTheCorrectError() async throws {
        let apiResponse = APIResponse<[String]>.init(success: false, errors: [.example], data: [], total: nil)
        let data = try JSONEncoder().encode(apiResponse)
        let apiService = APIService(networking: NetworkingMock(mockedData: data))
        
        do {
            let _: APIResponse<[String]> = try await apiService.request(.news(.list(limit: 1)))
            XCTFail("This call should throw an error.")
        } catch {
            guard let error = error as? APIError else {
                XCTFail("Expected APIError, got \(error)")
                return
            }
            XCTAssertEqual(error.code, apiResponse.errors.first!.code)
            XCTAssertEqual(error.translated, apiResponse.errors.first!.translated)
        }
    }

}
