//
//  Users.swift
//  
//
//  Created by Varun Chitturi on 12/7/22.
//

import Foundation

extension ZoomClient {
    
    static let usersEndpoint = ZoomClient.apiUrl.appending("users")
    
    public func getUser(_ credentials: BearerTokenSet, userId: String = "me") async throws -> User {
        return try await get(ZoomClient.usersEndpoint.appending(userId.description), decoding: User.self, credentials: credentials)
    }
    
}
