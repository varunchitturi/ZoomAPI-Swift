//
//  APITestCase.swift
//  
//
//  Created by Varun Chitturi on 12/5/22.
//

import Erik
import XCTest
import Vapor
import WebKit
import XCTVapor

@testable import ZoomAPI

class APITestCase: XCTestCase {
    
    let app = Application(.testing)
    private let clientID = Environment.get("ZM_CLIENT_ID")!
    private let clientSecret = Environment.get("ZM_CLIENT_SECRET")!
    private let email = Environment.get("ZM_EMAIL")!
    private let password = Environment.get("ZM_PASSWORD")!
    
    @MainActor let webView = WKWebView()
    
    override func setUp() async throws {
        app.post("code") { req in
            print(req)
            return "HELLO"
        }
    }

    
    var client: ZoomClient {
        ZoomClient(app.client, clientID: clientID, clientSecret: clientSecret)
    }
     
    /// Check if Zoom client config is available
    func testEnvironment() {
    }
    
    func testGetCode() async throws {
        
        let response = try await client.getToken(code: "0A4QdbIKLU6qhMYTrOXQgaDIlBwfXCFmg", redirectURI: "http://localhost:8080/code")
        
        print(response)
    }
    
    override func tearDown() {
        app.shutdown()
    }

}
