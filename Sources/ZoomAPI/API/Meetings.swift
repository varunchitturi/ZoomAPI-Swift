//
//  Meetings.swift
//  
//
//  Created by Varun Chitturi on 12/7/22.
//

import Foundation
import Vapor

extension ZoomClient {
    
    static let meetingsEndpoint = ZoomClient.apiUrl.appending("meetings")
    
    public func createMeeting(_ credentials: BearerTokenSet, userId: String = "me", meeting: Meeting) async throws -> (Meeting, MeetingInfo) {
        let response = try await post(ZoomClient.usersEndpoint.appending(userId).appending("meetings"), content: meeting, contentType: .json, credentials: credentials)
        return try response.content.decode((Meeting.self, MeetingInfo.self), using: responseDecoder)
    }
    
    
    public func getMeeting(_ credentials: BearerTokenSet, meetingId: UInt64) async throws -> (Meeting, MeetingInfo) {
        let response = try await get(ZoomClient.meetingsEndpoint.appending(meetingId.description), credentials: credentials)
        return try response.content.decode((Meeting.self, MeetingInfo.self), using: responseDecoder)
    }
    
    public func listMeetings(_ credentials: BearerTokenSet, filteredBy status: Meeting.Status = .scheduled, pageSize: Int = 30, nextPageToken: String? = nil, pageNumber: Int? = nil, userId: String = "me") async throws -> ([MeetingInfo], String?) {
        
        struct ListMeetingResponse: Decodable {
            let nextPageToken: String?
            let meetings: [MeetingInfo]
        }
        
        let listMeetingsResponse = try await get(ZoomClient.usersEndpoint.appending(userId).appending("meetings"), decoding: ListMeetingResponse.self,credentials: credentials) { req in
            try req.query.encode(["type": status.rawValue])
        }
        
        return (listMeetingsResponse.meetings, listMeetingsResponse.nextPageToken)
    }
    
    public func deleteMeeting(_ credentials: BearerTokenSet, meetingId: UInt64, occurrenceId: String? = nil, notifyHosts: Bool = true, notifyRegistrants: Bool = false) async throws {
        struct DeleteQuery: Content {
            let notifyHosts: Bool
            let notifyRegistrants: Bool
            let occurrenceId: String?
            
            enum CodingKeys: String, CodingKey {
                case notifyHosts = "schedule_for_reminder"
                case notifyRegistrants = "cancel_meeting_reminder"
                case occurrenceId = "occurrence_id"
            }
        }
        
        _ = try await delete(ZoomClient.meetingsEndpoint.appending(meetingId.description), content: DeleteQuery(notifyHosts: notifyHosts, notifyRegistrants: notifyRegistrants, occurrenceId: occurrenceId), credentials: credentials)
        
    }
    
    public func updateMeeting(_ credentials: BearerTokenSet, meetingId: UInt64, meeting: Meeting, occurrenceId: String? = nil) async throws {
        _ = try await patch(ZoomClient.meetingsEndpoint.appending(meetingId.description), content: meeting, credentials: credentials)
    }
    
    
}
