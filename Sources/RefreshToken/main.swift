//
//  main.swift
//  
//
//  Created by Varun Chitturi on 12/5/22.
//

import Vapor
import ZoomAPI
import Cocoa
import Fluent
import FluentSQLiteDriver

precondition(FileManager.default.currentDirectoryPath.pathComponents.last?.description == "TestData", "Please set the current directory in the RefreshToken scheme to the TestData folder")

let app = Application(.production)
let clientID = Environment.get("ZM_CLIENT_ID")!
let clientSecret = Environment.get("ZM_CLIENT_SECRET")!
let zoomClient = ZoomClient(app.client, clientID: clientID, clientSecret: clientSecret)
let codeRoute: PathComponent = "code"
let port = app.http.server.configuration.port
let redirectURI = URI("http://localhost:\(port)/\(codeRoute)")


let route = app.get(codeRoute) { req async throws in
    let code: String = req.query["code"]!
    let tokenSet = try await zoomClient.getToken(code: code, redirectURI: redirectURI)
    let tokenStorePath = FileManager.default.currentDirectoryPath.appending("/db.sqlite")
    if FileManager.default.fileExists(atPath: tokenStorePath) {
        let tableName = "persistent_values"
        app.databases.use(.sqlite(.file(tokenStorePath)), as: .sqlite)
        if let db = app.db as? SQLDatabase {
            try await db.raw(SQLQueryString(stringLiteral: "REPLACE INTO \(tableName) (key, value) VALUES ('ZM_REFRESH_TOKEN', '\(tokenSet.refreshToken)');")).run()
        }
    }
    
    req.logger.notice("Zoom Code: \(code) (Now Expired)")
    req.logger.notice("Zoom Access Token: \(tokenSet.accessToken) (Valid for 1 hour)")
    req.logger.notice("Zoom Refresh Token: \(tokenSet.refreshToken)")
    Task.detached {
        app.shutdown()
    }
    return HTTPStatus.ok
}

app.routes.add(route)
let runLoop = Task.detached {
    try app.run()
}

var baseURL = URLComponents(string: "https://zoom.us/oauth/authorize")!
baseURL.queryItems = [.init(name: "response_type", value: "code"),
                      .init(name: "client_id", value: clientID),
                      .init(name: "redirect_uri", value: redirectURI.description)]
NSWorkspace.shared.open(baseURL.url!)

try await runLoop.value
