//
//  main.swift
//  
//
//  Created by Varun Chitturi on 12/5/22.
//

import Vapor
import ZoomAPI
import Cocoa

let app = Application()
let clientID = Environment.get("ZM_CLIENT_ID")!
let clientSecret = Environment.get("ZM_CLIENT_SECRET")!
let zoomClient = ZoomClient(app.client, clientID: clientID, clientSecret: clientSecret)
let codeRoute: PathComponent = "code"
let port = app.http.server.configuration.port
let redirectURI = URI("http://localhost:\(port)/\(codeRoute)")

let route = app.get(codeRoute) { req async throws in
    let code: String = req.query["code"]!
    print(code)
    let tokenSet = try await zoomClient.getToken(code: code, redirectURI: redirectURI)
    print(tokenSet)
    app.shutdown()
    return HTTPStatus.ok
}

app.routes.add(route)

var baseURL = URLComponents(string: "https://zoom.us/oauth/authorize")!
baseURL.queryItems = [.init(name: "response_type", value: "code"),
                      .init(name: "client_id", value: clientID),
                      .init(name: "redirect_uri", value: redirectURI.description)]
NSWorkspace.shared.open(baseURL.url!)

try app.run()
