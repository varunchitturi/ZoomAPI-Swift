import XCTest
import Vapor
import Foundation
import Fluent
import FluentSQLiteDriver
@testable import ZoomAPI

final class OAuthTests: APITestCase {

    func testRefreshAccessToken() async throws {
        do {
            let tokenSet = try await client.refreshAccessToken(for: ZoomClient.BearerTokenSet(accessToken: "",
                                                                                              refreshToken: refreshToken,
                                                                                              expireDate: .now,
                                                                                              scope: ""))
            let refreshToken = try await PersistentKeyValue.find("ZM_REFRESH_TOKEN", on: app.db)
            refreshToken?.value = tokenSet.refreshToken
            try await refreshToken?.update(on: app.db)
        }
        catch {
            XCTAssertNoThrow(try { throw error }(), "Zoom Refresh Token expired or not found. Please run the RefreshToken executable.")
        }
        
    }
    
}
