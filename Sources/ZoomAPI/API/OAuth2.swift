//
//  OAuth2.swift
//  ZoomAPI
//
//  Created by Varun Chitturi on 12/3/22.
//

import Foundation
import Vapor

extension ZoomClient {
    
    private static let OAUTHEndpoint = URI("https://zoom.us/oauth/")
    
    private var tokenHeaders: HTTPHeaders {
        var headers = HTTPHeaders()
        headers.contentType = .urlEncodedForm
        headers.basicAuthorization = BasicAuthorization(username: clientID, password: clientSecret)
        return headers
    }
    
    private var tokenResponseDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    private struct TokenResponse: Content {
        var accessToken: String
        var tokenType: String
        var refreshToken: String
        var expiresIn: Double
        var scope: String
    }
    
    public func getToken(code: String, redirectURI: URI, codeVerifier: String? = nil) async throws -> BearerTokenSet {
        let response = try await client.post(ZoomClient.OAUTHEndpoint.appending("token")) { req in
            req.headers = tokenHeaders
            var body = ["code": code,
                        "grant_type": "authorization_code",
                        "redirect_uri": redirectURI.description
            ]
            if let codeVerifier {
                body.updateValue(codeVerifier, forKey: "code_verifier")
            }
            try req.query.encode(body)
        }
        
        let tokenResponse = try response.content.decode(TokenResponse.self, using: tokenResponseDecoder)
        return BearerTokenSet(accessToken: tokenResponse.accessToken,
                              refreshToken: tokenResponse.refreshToken,
                              expireDate: .init(timeIntervalSinceNow: tokenResponse.expiresIn),
                              scope: tokenResponse.scope
        )
    }
    
    public func refreshToken(for tokenSet: BearerTokenSet) async throws -> BearerTokenSet {
        let response = try await client.post(ZoomClient.OAUTHEndpoint.appending("token")) { req in
            req.headers = tokenHeaders
            try req.query.encode(["grant_type": "refresh_token", "refresh_token": tokenSet.refreshToken])
        }
        
        let tokenResponse = try response.content.decode(TokenResponse.self, using: tokenResponseDecoder)
        return BearerTokenSet(accessToken: tokenResponse.accessToken,
                              refreshToken: tokenResponse.refreshToken,
                              expireDate: .init(timeIntervalSinceNow: tokenResponse.expiresIn),
                              scope: tokenResponse.scope
        )
        
    }
    
    public func revokeToken(for tokenSet: BearerTokenSet) async throws {
        _ = try await client.post(ZoomClient.OAUTHEndpoint.appending("revoke")) { req in
            req.headers = tokenHeaders
            try req.query.encode(["token": tokenSet.accessToken])
        }
        
    }
    
}
