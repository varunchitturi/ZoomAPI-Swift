//
//  MeetingTests.swift
//  
//
//  Created by Varun Chitturi on 12/31/22.
//

import XCTest
import Vapor

@testable import ZoomAPI

final class MeetingTests: APITestCase {
    func testGetMeeting() async throws {
        let meeting = Meeting(type: .instant)
        try await client.createMeeting(tokenSet, meeting: meeting)
    }

}
