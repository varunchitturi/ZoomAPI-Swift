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
    let clientID = Environment.get("ZM_CLIENT_ID")!
    let clientSecret = Environment.get("ZM_CLIENT_SECRET")!
    var refreshToken: String!
    
    override func setUp() async throws {
        let testDataPath = URL(fileURLWithPath: #file).pathComponents.dropLast().joined(by: "/") + "/TestData"
        app.databases.use(.sqlite(.file("\(testDataPath)/db.sqlite")), as: .sqlite)
        app.migrations.add(PersistentKeyValueMigration())
        try await app.autoMigrate()
        refreshToken = try await PersistentKeyValue.find("ZM_REFRESH_TOKEN", on: app.db)?.value
        XCTAssertNotNil(refreshToken, "Zoom Refresh Token not found. Please run the RefreshToken executable.")
    }
    
    
    var client: ZoomClient {
        ZoomClient(app.client, clientID: clientID, clientSecret: clientSecret)
    }
    
    override func tearDown() {
        app.shutdown()
    }

}
