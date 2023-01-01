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
    
    public func createMeeting(_ credentials: BearerTokenSet, userId: String = "me", meeting: Meeting) async throws -> Meeting {
        let response = try await client.post(ZoomClient.usersEndpoint.appending(userId).appending("meetings")) { req in
            req.headers.bearerAuthorization = credentials.headers
            req.headers.contentType = .json
            try req.content.encode(meeting, using: requestEncoder)
        }
        return try response.content.decode(Meeting.self, using: responseDecoder)
    }
    
    
    public func getMeeting(_ credentials: BearerTokenSet, meetingId: UInt64) async throws -> (Meeting, MeetingInfo) {
        let response = try await client.get(ZoomClient.meetingsEndpoint.appending(meetingId.description)) { req in
            req.headers.bearerAuthorization = credentials.headers
        }
        
        struct GetMeetingResponse: Decodable {
            let meeting: Meeting
            let info: MeetingInfo
            
            init(from decoder: Decoder) throws {
                self.meeting = try Meeting(from: decoder)
                self.info = try MeetingInfo(from: decoder)
            }
        }
        
        let getMeetingResponse = try response.content.decode(GetMeetingResponse.self, using: responseDecoder)
        return (getMeetingResponse.meeting, getMeetingResponse.info)
    }
    
    public func listMeetings(_ credentials: BearerTokenSet, userId: String = "me") async throws -> [(Meeting, MeetingInfo)] {
        let listMeetingsResponse = try await client.get(ZoomClient.usersEndpoint.appending(userId).appending("meetings")) { req in
            req.headers.bearerAuthorization = credentials.headers
        }
        
        struct ListMeetingResponse: Decodable {
            let meetings: [MeetingOverview]
            
            struct MeetingOverview: Decodable {
                let id: UInt64
            }
        }
        
        let meetingIds = (try listMeetingsResponse.content.decode(ListMeetingResponse.self, using: responseDecoder)).meetings.map({$0.id})
        
        return try await withThrowingTaskGroup(of: (Meeting, MeetingInfo).self) { group in
            meetingIds.forEach { id in
                group.addTask {
                    return try await self.getMeeting(credentials, meetingId: id)
                }
            }
            
            var meetingDetails = [(Meeting, MeetingInfo)]()
            
            for try await (meeting, info) in group {
                meetingDetails.append((meeting, info))
            }
            
            return meetingDetails
        }
    }
    
    public func deleteMeeting(_ credentials: BearerTokenSet, meetingId: UInt64, occurrenceId: String? = nil, notifyHosts: Bool = true, notifyRegistrants: Bool = false) async throws {
        
        _ = try await client.delete(ZoomClient.meetingsEndpoint.appending(meetingId.description)) { req in
            req.headers.bearerAuthorization = credentials.headers
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
            try req.query.encode(DeleteQuery(notifyHosts: notifyHosts, notifyRegistrants: notifyRegistrants, occurrenceId: occurrenceId))
        }
        
    }
    
    
    
}
