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
    
    func testLinksDecodingCorrectly() throws {
        let json = """
        {
           "1471067972":{
              "2.4.0":[
                 {
                    "id":"1",
                    "host": "a"
                 },
                 {
                    "id":"2",
                    "host": "a"
                 }
              ],
              "2.19.3":[
                 {
                    "id":"3",
                    "host": "a"
                 }
              ]
           }
        }
        """
        let data = json.data(using: .utf8)!
        let response = try JSONDecoder().decode(LinksResponse.self, from: data)
        XCTAssertEqual(response.apps.count, 1)
        
        let app = try XCTUnwrap(response.apps.first)
        XCTAssertEqual(app.versions.count, 2)
        XCTAssertEqual(app.versions.map(\.number), ["2.19.3", "2.4.0"])
        
        let version = try XCTUnwrap(app.versions.first)
        XCTAssertEqual(version.links.count, 1)
        XCTAssertEqual(version.links.first, .init(id: "3", host: "a"))
    }

}
