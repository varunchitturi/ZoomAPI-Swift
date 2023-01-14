//
//  UserTests.swift
//  
//
//  Created by Varun Chitturi on 1/11/23.
//

import XCTest

@testable import ZoomAPI

final class UserTests: APITestCase {
    
    func testGetUser() async throws {
        _ = try await client.getUser(tokenSet)
    }
    
    func testCreateUser() async throws {
        let userInfo = UserInfo(email: "test@test.com", firstName: "", lastName: "", displayName: "", password: "", type: .basic)
        try await client.createUser(tokenSet, userInfo: userInfo)
    }
    
    func testUpdateUser() async throws {
        var user = try await client.getUser(tokenSet)
        let originalDisplayName = user.displayName
        user.displayName = "Test Display Name"
        try await client.updateUser(tokenSet, updatedUser: user)
        let updatedUser = try await client.getUser(tokenSet)
        XCTAssert(updatedUser.displayName == user.displayName)
        user.displayName = originalDisplayName
        try await client.updateUser(tokenSet, updatedUser: user)
    }
    
    func testListUsers() async throws {
        let users = try await client.listUsers(tokenSet).users
    }
    
    
}
