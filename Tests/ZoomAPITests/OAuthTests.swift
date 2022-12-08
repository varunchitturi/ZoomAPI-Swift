import XCTest
import Vapor
import Foundation
import Fluent
import FluentSQLiteDriver
@testable import ZoomAPI

final class OAuthTests: APITestCase {

    func testRefreshAccessToken() async throws {
        print(tokenSet.refreshToken)
        do {
            try await refreshTokenSet(refreshToken: tokenSet.refreshToken)
        }
        catch {
            XCTAssertNoThrow(try { throw error }(), "Test may have failed because Zoom Refresh Token is expired or not found. Please run the RefreshToken executable.")
        }
        
    }
    
}
