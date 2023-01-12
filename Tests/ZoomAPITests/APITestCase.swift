//
//  APITestCase.swift
//  
//
//  Created by Varun Chitturi on 12/5/22.
//

import XCTest
import Vapor

@testable import ZoomAPI

class APITestCase: XCTestCase {
    
    let app = Application()
    let clientId = Environment.get("ZM_CLIENT_ID")!
    let clientSecret = Environment.get("ZM_CLIENT_SECRET")!
    private(set) var tokenSet: ZoomClient.BearerTokenSet!
    
    
    override func setUp() async throws {
        app.http.client.configuration.proxy = .server(host: "localhost", port: 9090)
        let testDataPath = URL(fileURLWithPath: #file).pathComponents.dropLast().joined(by: "/") + "/TestData"
        app.databases.use(.sqlite(.file("\(testDataPath)/db.sqlite")), as: .sqlite)
        app.migrations.add(PersistentKeyValueMigration())
        try await app.autoMigrate()
        let refreshToken = try await PersistentKeyValue.find("ZM_REFRESH_TOKEN", on: app.db)?.value ?? ""
        XCTAssertNotEqual(refreshToken, "", "Zoom Refresh Token not found. Please run the RefreshToken executable.")
        try await refreshTokenSet(refreshToken: refreshToken)
    }
    
    func refreshTokenSet(refreshToken: String) async throws {
        tokenSet = try await client.refreshAccessToken(for: ZoomClient.BearerTokenSet(accessToken: "",
                                                                                          refreshToken: refreshToken,
                                                                                          expireDate: .now,
                                                                                          scope: ""))
        
        let refreshToken = try await PersistentKeyValue.find("ZM_REFRESH_TOKEN", on: app.db)
        refreshToken?.value = tokenSet.refreshToken
        try await refreshToken?.update(on: app.db)
    }
    
    var client: ZoomClient {
        ZoomClient(app.client, clientId: clientId, clientSecret: clientSecret)
    }
    
    override func tearDown() async throws {
        app.shutdown()
    }

}
