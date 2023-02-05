//
//  Users.swift
//  
//
//  Created by Varun Chitturi on 12/7/22.
//

import Foundation
import Vapor

extension ZoomClient {
    
    static let usersEndpoint = ZoomClient.apiUrl.appending("users")
    
    /// Get a User by ID.
    ///
    /// - Parameters:
    ///   - credentials: BearerTokenSet containing access and refresh tokens.
    ///   - userId: ID of the User to retrieve (default value is "me").
    /// - Throws:
    ///    - `AbortError`: If the API returns an error.
    ///    - `DecodingError` if the server response could not be decoded.
    /// - Returns:
    ///   A User object with the specified User's information.
    public func getUser(_ credentials: BearerTokenSet, userId: String = "me") async throws -> User {
        return try await get(ZoomClient.usersEndpoint.appending(userId), decoding: User.self, credentials: credentials)
    }
    
    /// Create a User with the specified information.
    ///
    /// - Parameters:
    ///   - credentials: BearerTokenSet containing access and refresh tokens.
    ///   - action: Action to perform on the User (default value is .create).
    ///   - userInfo: Information for the User to be created.
    /// - Throws:
    ///    - `AbortError`: If the API returns an error.
    public func createUser(_ credentials: BearerTokenSet, action: UserCreateAction = .create, userInfo: UserInfo) async throws {
        struct CreateUserRequest: Content {
            let action: UserCreateAction
            let userInfo: UserInfo
        }
        
        _ = try await post(ZoomClient.usersEndpoint, content: CreateUserRequest(action: action, userInfo: userInfo), contentType: .json, credentials: credentials)
    }
    
    /// Delete a User by ID.
    ///
    /// - Parameters:
    ///   - credentials: BearerTokenSet containing access and refresh tokens.
    ///   - userId: ID of the User to delete (default value is "me").
    ///   - action: Action to perform on the User.
    /// - Throws:
    ///    - `AbortError`: If the API returns an error.
    public func deleteUser(_ credentials: BearerTokenSet, userId: String = "me", action: UserDeleteAction) async throws {
        _ = try await delete(ZoomClient.usersEndpoint.appending(userId), content: action, credentials: credentials)
    }
    
    /// Delete a User by ID with additional parameters.
    ///
    /// - Parameters:
    ///   - credentials: BearerTokenSet containing access and refresh tokens.
    ///   - userId: ID of the User to delete (default value is "me").
    ///   - action: Action to perform on the User.
    ///   - transferEmail: Email address to transfer ownership to.
    ///   - transferMeeting: Transfer meeting ownership.
    ///   - transferWebinar: Transfer webinar ownership.
    ///   - transferRecording: Transfer recording ownership.
    ///   - transferWhiteboard: Transfer whiteboard ownership.
    /// - Throws:
    ///    - `AbortError`: If the API returns an error..
    public func deleteUser(_ credentials: BearerTokenSet, userId: String = "me", action: UserDeleteAction, transferEmail: String, transferMeeting: Bool, transferWebinar: Bool, transferRecording: Bool, transferWhiteboard: Bool) async throws {
        
        struct DeleteUserRequest: Content {
            let action: UserDeleteAction
            let transferEmail: String
            let transferMeeting: Bool
            let transferWebinar: Bool
            let transferRecoding: Bool
            let transferWhiteboard: Bool
            
            enum CodingKeys: String, CodingKey {
                case action
                case transferEmail = "transfer_email"
                case transferMeeting = "transfer_meeting"
                case transferWebinar = "transfer_webinar"
                case transferRecoding = "transfer_recording"
                case transferWhiteboard = "transfer_whiteboard"
            }
        }
        
        let deleteRequest = DeleteUserRequest(action: action,
                                              transferEmail: transferEmail,
                                              transferMeeting: transferMeeting,
                                              transferWebinar: transferWebinar,
                                              transferRecoding: transferRecording,
                                              transferWhiteboard: transferWhiteboard)
        
        _ = try await delete(ZoomClient.usersEndpoint.appending(userId), content: deleteRequest, credentials: credentials)
    }
    
    /// Update a User with new information.
    ///
    /// - Parameters:
    ///   - credentials: BearerTokenSet containing access and refresh tokens.
    ///   - updatedUser: The updated User information.
    ///   - userId: ID of the User to update (default value is "me").
    /// - Throws:
    ///    - `AbortError`: If the API returns an error.
    public func updateUser(_ credentials: BearerTokenSet, updatedUser: User, userId: String = "me") async throws {
        _ = try await patch(ZoomClient.usersEndpoint.appending(userId), content: updatedUser, credentials: credentials)
        
    }
    
    /// List all Users with the specified status and role.
    ///
    /// - Parameters:
    ///   - credentials: BearerTokenSet containing access and refresh tokens.
    ///   - status: Status of the Users to retrieve (default value is .active).
    ///   - roleId: ID of the role of the Users to retrieve (default value is nil).
    ///   - pageNumber: Page number of the results to retrieve (default value is 1).
    ///   - pageSize: Number of results per page (default value is 30).
    ///   - nextPageToken: Token for retrieving the next page of results (default value is nil).
    /// - Throws:
    ///    - `AbortError`: If the API returns an error.
    ///    - `DecodingError` if the server response could not be decoded.
    /// - Returns:
    ///   A tuple containing an array of Users and a next page token.
    public func listUsers(_ credentials: BearerTokenSet, status: User.Status = .active, roleId: String? = nil, pageNumber: Int = 1, pageSize: Int = 30, nextPageToken: String? = nil) async throws -> (users: [User], nextPageToken: String?) {
        
        struct ListUsersResponse: Content {
            let users: [User]
            let nextPageToken: String?
        }
        
        let listUserResponse = try await get(ZoomClient.usersEndpoint, decoding: ListUsersResponse.self, credentials: credentials) { req in
            struct ListUsersRequest: Content {
                let status: User.Status
                let roleId: String?
                let pageNumber: Int
                let pageSize: Int
                let nextPageToken: String?
                
                enum CodingKeys: String, CodingKey {
                    case status
                    case roleId = "role_id"
                    case pageNumber = "page_number"
                    case pageSize = "page_size"
                    case nextPageToken = "next_page_token"
                }
            }
            
            let listRequest = ListUsersRequest(status: status, roleId: roleId, pageNumber: pageNumber, pageSize: pageSize, nextPageToken: nextPageToken)
            
            try req.query.encode(listRequest)
        }
        return (listUserResponse.users, listUserResponse.nextPageToken)
    }
    
}
