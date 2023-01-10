import XCTest
@testable import Models

final class ModelsTests: XCTestCase {
    
    func testAPIResponseDecodingTotalWhenTotalIsString() throws {
        let json = """
        {
            "success": true,
            "errors": [],
            "data": "",
            "total": "20"
        }
        """ 
        let data = json.data(using: .utf8)!

        let response = try! JSONDecoder().decode(APIResponse<String>.self, from: data)
        
        let total = try XCTUnwrap(response.total)
        XCTAssertEqual(total, 20)
    }
    
    func testAPIResponseDecodingTotalWhenTotalIsInt() throws {
        let json = """
        {
            "success": true,
            "errors": [],
            "data": "",
            "total": 20
        }
        """
        let data = json.data(using: .utf8)!

        let response = try! JSONDecoder().decode(APIResponse<String>.self, from: data)
        
        let total = try XCTUnwrap(response.total)
        XCTAssertEqual(total, 20)
    }

}
