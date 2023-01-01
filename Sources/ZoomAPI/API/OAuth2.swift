//
//  OAuth2.swift
//  ZoomAPI
//
//  Created by Varun Chitturi on 12/3/22.
//

import Foundation
import Vapor

extension ZoomClient {
    
    private static let oauthEndpoint = URI("https://zoom.us/oauth/")
    
    private var tokenHeaders: HTTPHeaders {
        var headers = HTTPHeaders()
        headers.contentType = .urlEncodedForm
        headers.basicAuthorization = BasicAuthorization(username: clientId, password: clientSecret)
        return headers
    }
    
    private struct TokenResponse: Content {
        let accessToken: String
        let tokenType: String
        let refreshToken: String
        let expiresIn: Double
        let scope: String
    }
    
    /// Get's a set of bearer credentials using an authorization code sent to the redirect URI.
    /// - Parameters:
    ///   - code: The code given when a user authorizes your app
    ///   - redirectUri: The URI that Zoom redirects too with the code when an app is authorized
    ///   - codeVerifier: An optional String used to verify the code if using PKCE
    /// - Returns: A `BearerTokenSet` containing the user's credentials
    public func getToken(code: String, redirectUri: URI, codeVerifier: String? = nil) async throws -> BearerTokenSet {
        let response = try await client.post(ZoomClient.oauthEndpoint.appending("token")) { req in
            req.headers = tokenHeaders
            var body = ["code": code,
                        "grant_type": "authorization_code",
                        "redirect_uri": redirectUri.description
            ]
            if let codeVerifier {
                body.updateValue(codeVerifier, forKey: "code_verifier")
            }
            try req.query.encode(body)
        }
        
        let tokenResponse = try response.content.decode(TokenResponse.self, using: responseDecoder)
        return BearerTokenSet(accessToken: tokenResponse.accessToken,
                              refreshToken: tokenResponse.refreshToken,
                              expireDate: .init(timeIntervalSinceNow: tokenResponse.expiresIn),
                              scope: tokenResponse.scope
        )
    }
    
    /// Refreshes an expired access token.
    /// - Note: A new access token **and** refresh token will be provided
    /// - Parameter tokenSet: The bearer token set for the user
    /// - Returns: A `BearerTokenSet` with refreshed credentials
    public func refreshAccessToken(for tokenSet: BearerTokenSet) async throws -> BearerTokenSet {
        let response = try await client.post(ZoomClient.oauthEndpoint.appending("token")) { req in
            req.headers = tokenHeaders
            try req.query.encode(["grant_type": "refresh_token", "refresh_token": tokenSet.refreshToken])
        }
        
        let tokenResponse = try response.content.decode(TokenResponse.self, using: responseDecoder)
        return BearerTokenSet(accessToken: tokenResponse.accessToken,
                              refreshToken: tokenResponse.refreshToken,
                              expireDate: .init(timeIntervalSinceNow: tokenResponse.expiresIn),
                              scope: tokenResponse.scope
        )
        
    }
    
    /// Revokes a user's access and refresh token.
    /// - Note: The user must manually reauthorize the Zoom App after the tokens are revoked
    /// - Parameter tokenSet: The bearer token set for the user
    public func revokeToken(for tokenSet: BearerTokenSet) async throws {
        _ = try await client.post(ZoomClient.oauthEndpoint.appending("revoke")) { req in
            req.headers = tokenHeaders
            try req.query.encode(["token": tokenSet.accessToken])
        }
    }
    
}
