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
        try await client.getMeeting(tokenSet, meetingId: 4398410090)
    }
    
    func testListMeetings() async throws {
        try await client.listMeetings(tokenSet)
    }

}
