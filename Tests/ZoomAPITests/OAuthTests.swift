import XCTest
@testable import ZoomAPI

final class OAuthTests: APITestCase {

    func testRefreshAccessToken() async throws {
        do {
            try await refreshTokenSet(refreshToken: tokenSet.refreshToken)
        }
        catch {
            XCTAssertNoThrow(try { throw error }(), "Test may have failed because Zoom Refresh Token is expired or not found. Please run the RefreshToken executable.")
        }
        
    }
    
}
