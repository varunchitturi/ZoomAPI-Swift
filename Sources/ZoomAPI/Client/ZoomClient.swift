//
//  ZoomClient.swift
//  
//
//  Created by Varun Chitturi on 12/3/22.
//

import Foundation
import Vapor

open class ZoomClient {
    
    static let apiURL = URI(string: "https://api.zoom.us/v2/")
        
    public var client: Client
    let clientID: String
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
    
    public init(_ client: Client, clientID: String, clientSecret: String) {
        self.client = client
        self.clientID = clientID
        self.clientSecret = clientSecret
    }

    
    
}
