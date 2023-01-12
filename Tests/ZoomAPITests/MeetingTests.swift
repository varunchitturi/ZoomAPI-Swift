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
    
    var meetingsToDelete = [Meeting]()
    
    func testCreateMeeting() async throws {
        let testMeeting = Meeting(type: .scheduled)
        let createdMeeting = try await client.createMeeting(tokenSet, meeting: testMeeting)
        meetingsToDelete.append(createdMeeting)
        XCTAssert(Calendar.current.isDate(testMeeting.startTime, equalTo: createdMeeting.startTime, toGranularity: .second))
        XCTAssert(testMeeting.settings == createdMeeting.settings)
        XCTAssert(testMeeting.trackingFields == createdMeeting.trackingFields)
    }
    
    func testGetMeeting() async throws {
        let testMeeting = try await client.createMeeting(tokenSet, meeting: Meeting(type: .scheduled))
        meetingsToDelete.append(testMeeting)
        let meeting = try await client.getMeeting(tokenSet, meetingId: testMeeting.info!.id)
        XCTAssertNotNil(meeting.info)
        XCTAssert(meeting.info?.id == testMeeting.info?.id)
    }
    
    func testListMeetings() async throws {
        let testMeeting = try await client.createMeeting(tokenSet, meeting: Meeting(type: .scheduled))
        meetingsToDelete.append(testMeeting)
        var (meetingInfos, nextPageToken) = try await client.listMeetings(tokenSet)
        var meetingFound = false
        while nextPageToken != nil && meetingFound == false {
            if meetingInfos.contains(where: {$0.id == testMeeting.info?.id}) {
                meetingFound = true
            }
            else {
                (meetingInfos, nextPageToken) = try await client.listMeetings(tokenSet)
            }
        }
        XCTAssert(meetingFound)
    }
     
    func testDeleteMeeting() async throws {
        let testMeeting = try await client.createMeeting(tokenSet, meeting: Meeting(type: .scheduled))
        try await client.deleteMeeting(tokenSet, meetingId: testMeeting.info!.id, notifyHosts: false)
        var meetingNotFound = false
        do {
            _ = try await client.getMeeting(tokenSet, meetingId: testMeeting.info!.id)
        }
        catch {
            meetingNotFound = true
        }
        XCTAssert(meetingNotFound)
    }
    
    func testUpdateMeeting() async throws {
        let createdMeeting = try await client.createMeeting(tokenSet, meeting: Meeting(type: .scheduled))
        meetingsToDelete.append(createdMeeting)
        try await client.updateMeeting(tokenSet, meetingId: createdMeeting.info!.id, meeting: Meeting(agenda: "Updated Agenda", type: .scheduled))
        let updatedMeeting = try await client.getMeeting(tokenSet, meetingId: createdMeeting.info!.id)
        XCTAssert(updatedMeeting.agenda != createdMeeting.agenda && updatedMeeting.agenda == "Updated Agenda")
        XCTAssert(createdMeeting.info!.id == updatedMeeting.info!.id)
    }
    
    override func tearDown() async throws {
        for meeting in meetingsToDelete {
            if let id = meeting.info?.id {
                try await client.deleteMeeting(tokenSet, meetingId: id, notifyHosts: false)
            }
        }
        try await super.tearDown()
    }

}
