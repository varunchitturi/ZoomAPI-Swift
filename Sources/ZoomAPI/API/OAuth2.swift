//
//  OAuth2.swift
//  ZoomAPI
//
//  Created by Varun Chitturi on 12/3/22.
//

import Foundation
import Vapor

extension ZoomClient {
    
    public func getToken(code: String) async throws -> String {
        
        let verifier = UUID().description
        let response = try await self.client.post("https://zoom.us/oauth/token") { req in
            req.headers = tokenHeaders
            try req.query.encode(["code": code,
                                  "grant_type": "authorization_code",
                                  "redirect_uri": "",
                                  "code_verifier": verifier
                                 ])
        }
        
        return response.description
    }
    
    private var tokenHeaders: HTTPHeaders {
        var headers = HTTPHeaders()
        headers.contentType = .urlEncodedForm
        headers.basicAuthorization = BasicAuthorization(username: clientID, password: clientSecret)
        return headers
    }
    
}
