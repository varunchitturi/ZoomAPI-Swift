//
//  MeetingTests.swift
//  
//
//  Created by Varun Chitturi on 12/31/22.
//

import XCTest
@testable import ZoomAPI

final class MeetingTests: APITestCase {
    func testGetMeeting() async throws {
        try await client.createMeeting(tokenSet, meeting: Meeting(type: .instant))
    }

}
