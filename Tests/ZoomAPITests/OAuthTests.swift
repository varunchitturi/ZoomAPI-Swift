import XCTest
import Vapor
@testable import ZoomAPI

final class OAuthTests: XCTestCase {
    
    let app = Application()
    
    /// Check if Zoom client config is available
    func testEnvironment() async throws {
        XCTAssertNotNil(Environment.get("ZM_CLIENT_ID"))
        XCTAssertNotNil(Environment.get("ZM_CLIENT_SECRET"))
    }
    
    override func tearDown() {
        
    }
    
}
