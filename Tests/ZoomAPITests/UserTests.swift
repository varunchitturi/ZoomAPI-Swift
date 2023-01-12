//
//  UserTests.swift
//  
//
//  Created by Varun Chitturi on 1/11/23.
//

import XCTest

final class UserTests: APITestCase {
    
    func testGetMeeting() async throws {
        _ = try await client.getUser(tokenSet)
    }

}
