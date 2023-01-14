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
    
    /**
        This function creates a meeting for the given userId and meeting information
        - Parameters:
            - credentials: BearerTokenSet to provide the authentication for API call
            - userId: User id for whom meeting needs to be created, default value is "me"
            - meeting: Meeting object which contains the information of the meeting to be created
        - Returns: Meeting object which contains the information of the created meeting
        - Throws:
            - `AbortError`: If the API returns an error.
            - `ContentDecodingError`: If the received data is not in the expected format.
    */
    public func createMeeting(_ credentials: BearerTokenSet, userId: String = "me", meeting: Meeting) async throws -> Meeting {
        let response = try await post(ZoomClient.usersEndpoint.appending(userId).appending("meetings"), content: meeting, contentType: .json, credentials: credentials)
        var (meeting, meetingInfo) = try response.content.decode((Meeting.self, MeetingInfo.self), using: responseDecoder)
        meeting.info = meetingInfo
        return meeting
    }
    
    /**
        Retrieves information about a Zoom meeting with the given `meetingId`.
     
        - Parameters:
            - credentials: BearerTokenSet object for Authentication
            - meetingId: The ID of the meeting to retrieve information about.
     
        - Returns:
            The `Meeting` object representing the meeting with the given ID, including additional `MeetingInfo` information.
     
        - Throws:
            - `AbortError`: If the API returns an error.
            - `DecodingError` if the server response could not be decoded into `Meeting` and `MeetingInfo` model.
     */
    public func getMeeting(_ credentials: BearerTokenSet, meetingId: UInt64) async throws -> Meeting {
        let response = try await get(ZoomClient.meetingsEndpoint.appending(meetingId.description), credentials: credentials)
        var (meeting, meetingInfo) = try response.content.decode((Meeting.self, MeetingInfo.self), using: responseDecoder)
        meeting.info = meetingInfo
        return meeting
    }
    
    /**
        Lists meetings for a user based on the provided filters.
        - Parameters:
            - credentials: The bearer token set used to authenticate the request.
            - status: The status of the meetings to filter by. Defaults to `.scheduled`.
            - pageSize: The number of meetings to return per page. Defaults to 30.
            - nextPageToken: The token to use to retrieve the next page of results.
            - pageNumber: The number of the page to retrieve.
            - userId: The id of the user for whom to list meetings. Defaults to "me".
        - Returns:
            - A tuple containing an array of `MeetingInfo` objects and a string representing the next page token.
            - if fails to retrieve the meetings, it throws an error.
        - Throws:
            - `AbortError`: If the API returns an error.
            - `DecodingError` if the server response could not be decoded into `Meeting` and `MeetingInfo` model.
     */
    public func listMeetings(_ credentials: BearerTokenSet, filteredBy status: Meeting.Status = .scheduled, pageSize: Int = 30, nextPageToken: String? = nil, pageNumber: Int? = nil, userId: String = "me") async throws -> (meetings: [MeetingInfo], nextPageToken: String?) {
        
        struct ListMeetingResponse: Decodable {
            let nextPageToken: String?
            let meetings: [MeetingInfo]
        }
        
        let listMeetingsResponse = try await get(ZoomClient.usersEndpoint.appending(userId).appending("meetings"), decoding: ListMeetingResponse.self,credentials: credentials) { req in
            try req.query.encode(["type": status.rawValue])
        }
        
        return (listMeetingsResponse.meetings, listMeetingsResponse.nextPageToken)
    }
    
    /**
        The function is used to delete a specific meeting based on the provided meetingId
        - Parameters:
           - credentials: Bearer token set needed for authorize the API request
           - meetingId:  A unique identifier for the meeting
           - occurrenceId: The specific occurrence id of the meeting if available
           - notifyHosts: Boolean flag to notify hosts after deletion, default value is true
           - notifyRegistrants: Boolean flag to notify registrants after deletion, default value is false
        - Throws:
            - `AbortError`: If the API returns an error.
    */
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
    
    /**
        Update a meeting
        - Parameters:
           - credentials: The bearer token set to use for the request
           - meetingId: The ID of the meeting to update.
           - meeting: The updated information for the meeting
           - occurrenceId: The meeting occurrence ID if the meeting is a recurring meeting.
        - Throws:
            - `AbortError`: If the API returns an error.
    */
    public func updateMeeting(_ credentials: BearerTokenSet, meetingId: UInt64, meeting: Meeting, occurrenceId: String? = nil) async throws {
        _ = try await patch(ZoomClient.meetingsEndpoint.appending(meetingId.description), content: meeting, credentials: credentials)
    }
}
