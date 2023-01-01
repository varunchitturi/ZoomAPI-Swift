//
//  Meetings.swift
//  
//
//  Created by Varun Chitturi on 12/7/22.
//

import Foundation

extension ZoomClient {
    
    static let meetingsEndpoint = ZoomClient.apiURL.appending("meetings")
    
    public func createMeeting(_ credentials: BearerTokenSet, userID: String = "me", meeting: Meeting) async throws -> Meeting {
        let response = try await client.post(ZoomClient.usersEndpoint.appending(userID).appending("meetings")) { req in
            req.headers.bearerAuthorization = credentials.headers
            req.headers.contentType = .json
            try req.content.encode(meeting, using: requestEncoder)
        }
        let meeting =  try response.content.decode(Meeting.self, using: responseDecoder)
        print(meeting)
        return meeting
    }
    
    
    public func getMeeting(_ credentials: BearerTokenSet, meetingID: UInt64) async throws -> Meeting {
        let response = try await client.get(ZoomClient.meetingsEndpoint.appending(meetingID.description)) { req in
            req.headers.bearerAuthorization = credentials.headers
        }
        return try response.content.decode(Meeting.self, using: responseDecoder)
    }
    
    
    
}
