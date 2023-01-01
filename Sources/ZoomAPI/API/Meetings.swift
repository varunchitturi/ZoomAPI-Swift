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
        
        struct GetMeetingResponse: Content {
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
    
    
    
}
