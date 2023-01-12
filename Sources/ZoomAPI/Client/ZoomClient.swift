//
//  ZoomClient.swift
//  
//
//  Created by Varun Chitturi on 12/3/22.
//

import Foundation
import Vapor

open class ZoomClient {
    
    static let apiUrl = URI(string: "https://api.zoom.us/v2/")
        
    var client: Client
    let clientId: String
    let clientSecret: String
    
    let responseDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    let requestEncoder: JSONEncoder = {
        let encoder  = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()
    
    public init(_ client: Client, clientId: String, clientSecret: String) {
        self.client = client
        self.clientId = clientId
        self.clientSecret = clientSecret
    }
    
    private func checkResponseStatus(_ response: ClientResponse) throws {
        if response.status.code >= 400 {
            throw Abort(response.status, reason: response.description)
        }
    }
    

    func get<T: Decodable>(_ url: URI, decoding decodable: T.Type, credentials: BearerTokenSet, beforeSend: (inout ClientRequest) throws -> Void = {_ in }) async throws -> T {
        
        let response = try await get(url, credentials: credentials) { req in
            try beforeSend(&req)
        }
        return try response.content.decode(decodable, using: responseDecoder)
    }
    
    func get(_ url: URI, credentials: BearerTokenSet, beforeSend: (inout ClientRequest) throws -> Void = {_ in }) async throws -> ClientResponse {
        let response = try await client.get(url) { req in
            req.headers.bearerAuthorization = credentials.headers
            try beforeSend(&req)
        }
        
        try checkResponseStatus(response)
    
        return response
    }
    
    func post<T: Encodable, U: Decodable>(_ url: URI, content: T, decoding decodable: U.Type, contentType: HTTPMediaType, credentials: BearerTokenSet,  beforeSend: (inout ClientRequest) throws -> Void = {_ in }) async throws -> U {
        let response = try await post(url, content: content, contentType: contentType, credentials: credentials) { req in
            try beforeSend(&req)
        }
        return try response.content.decode(decodable, using: responseDecoder)
    }
    
    func post<T: Encodable>(_ url: URI, content: T, contentType: HTTPMediaType, credentials: BearerTokenSet, beforeSend: (inout ClientRequest) throws -> Void = {_ in }) async throws -> ClientResponse {
        precondition(contentType == .json || contentType == .urlEncodedForm, "The Zoom API only accepts post requests with JSON and URL Encoded content types.")
        let response = try await client.post(url) { req in
            req.headers.bearerAuthorization = credentials.headers
            req.headers.contentType = contentType
            if contentType == .json {
                try req.content.encode(content, using: requestEncoder)
            }
            else if contentType == .urlEncodedForm {
                try req.query.encode(content)
            }
            try beforeSend(&req)
        }
        
        try checkResponseStatus(response)
    
        return response
    
    }
    
    func patch<T: Encodable>(_ url: URI, content: T, credentials: BearerTokenSet, beforeSend: (inout ClientRequest) throws -> Void = {_ in }) async throws -> ClientResponse {
        let response = try await client.patch(url) { req in
            req.headers.bearerAuthorization = credentials.headers
            req.headers.contentType = .json
            try req.content.encode(content, using: requestEncoder)
            try beforeSend(&req)
        }
        
        try checkResponseStatus(response)
    
        return response
    
    }
    
    
    func delete<T: Encodable>(_ url: URI, content: T, credentials: BearerTokenSet, beforeSend: (inout ClientRequest) throws -> Void = {_ in }) async throws -> ClientResponse {
        let response = try await client.delete(url) { req in
            req.headers.bearerAuthorization = credentials.headers
            try req.query.encode(content)
            try beforeSend(&req)
        }
        
        try checkResponseStatus(response)
    
        return response
    
    }
    
}
