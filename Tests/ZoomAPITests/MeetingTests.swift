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
    
    var meetingsToDelete = [MeetingInfo]()
    
    func testCreateMeeting() async throws {
        let testMeeting = Meeting(type: .scheduled)
        let (createdMeeting, createdMeetingInfo) = try await client.createMeeting(tokenSet, meeting: testMeeting)
        meetingsToDelete.append(createdMeetingInfo)
        XCTAssert(Calendar.current.isDate(testMeeting.startTime, equalTo: createdMeeting.startTime, toGranularity: .second))
        XCTAssert(testMeeting.settings == createdMeeting.settings)
        XCTAssert(testMeeting.trackingFields == createdMeeting.trackingFields)
    }
    
    func testGetMeeting() async throws {
        let (_, testMeetingInfo) = try await client.createMeeting(tokenSet, meeting: Meeting(type: .scheduled))
        meetingsToDelete.append(testMeetingInfo)
        let (_, meetingInfo) = try await client.getMeeting(tokenSet, meetingId: testMeetingInfo.id)
        XCTAssert(meetingInfo.id == testMeetingInfo.id)
    }
    
    func testListMeetings() async throws {
        let (_, testMeetingInfo) = try await client.createMeeting(tokenSet, meeting: Meeting(type: .scheduled))
        meetingsToDelete.append(testMeetingInfo)
        var (meetingInfos, nextPageToken) = try await client.listMeetings(tokenSet)
        var meetingFound = false
        while nextPageToken != nil && meetingFound == false {
            if meetingInfos.contains(where: {$0.id == testMeetingInfo.id}) {
                meetingFound = true
            }
            else {
                (meetingInfos, nextPageToken) = try await client.listMeetings(tokenSet)
            }
        }
        XCTAssert(meetingFound)
    }
     
    func testDeleteMeeting() async throws {
        let (_, testMeetingInfo) = try await client.createMeeting(tokenSet, meeting: Meeting(type: .scheduled))
        try await client.deleteMeeting(tokenSet, meetingId: testMeetingInfo.id, notifyHosts: false)
        var meetingNotFound = false
        do {
            _ = try await client.getMeeting(tokenSet, meetingId: testMeetingInfo.id)
        }
        catch {
            meetingNotFound = true
        }
        XCTAssert(meetingNotFound)
    }
    
    func testUpdateMeeting() async throws {
        let (createdMeeting, createdMeetingInfo) = try await client.createMeeting(tokenSet, meeting: Meeting(type: .scheduled))
        meetingsToDelete.append(createdMeetingInfo)
        try await client.updateMeeting(tokenSet, meetingId: createdMeetingInfo.id, meeting: Meeting(agenda: "Updated Agenda", type: .scheduled))
        let (updatedMeeting, updatedMeetingInfo) = try await client.getMeeting(tokenSet, meetingId: createdMeetingInfo.id)
        XCTAssert(updatedMeeting.agenda != createdMeeting.agenda && updatedMeeting.agenda == "Updated Agenda")
        XCTAssert(createdMeetingInfo.id == updatedMeetingInfo.id)
    }
    
    override func tearDown() async throws {
        for meeting in meetingsToDelete {
            try await client.deleteMeeting(tokenSet, meetingId: meeting.id, notifyHosts: false)
        }
        try await super.tearDown()
    }

}
