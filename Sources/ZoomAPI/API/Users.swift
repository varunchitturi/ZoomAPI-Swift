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
    
    public func getUser(_ credentials: BearerTokenSet, userId: String = "me") async throws -> User {
        return try await get(ZoomClient.usersEndpoint.appending(userId), decoding: User.self, credentials: credentials)
    }
    
    public func createUser(_ credentials: BearerTokenSet, action: UserCreateAction = .create, userInfo: UserInfo) async throws {
        struct CreateUserRequest: Content {
            let action: UserCreateAction
            let userInfo: UserInfo
        }
        
        _ = try await post(ZoomClient.usersEndpoint, content: CreateUserRequest(action: action, userInfo: userInfo), contentType: .json, credentials: credentials)
    }
    
    public func deleteUser(_ credentials: BearerTokenSet, userId: String = "me", action: UserDeleteAction) async throws {
        _ = try await delete(ZoomClient.usersEndpoint.appending(userId), content: action, credentials: credentials)
    }
    
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
    
    public func updateUser(_ credentials: BearerTokenSet, updatedUser: User, userId: String = "me") async throws {
        _ = try await patch(ZoomClient.usersEndpoint.appending(userId), content: updatedUser, credentials: credentials)
        
    }
    
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
