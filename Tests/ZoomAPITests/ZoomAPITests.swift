import XCTest
import Vapor
@testable import ZoomAPI

final class ZoomAPITests: XCTestCase {
    func testExample() async throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        
        let app = Application()
        let client = ZoomClient(app.client, clientID: "", clientSecret: "")
        let response = try await client.getToken(code: "")
        print(response)
        // XCTAssertEqual(ZoomAPI().text, "Hello, World!")
    }
    
}
