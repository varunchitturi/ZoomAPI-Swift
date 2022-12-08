//
//  BearerTokenSet.swift
//  
//
//  Created by Varun Chitturi on 12/4/22.
//

import Foundation
import Vapor

extension ZoomClient {
    public struct BearerTokenSet {
        public let accessToken: String
        public let refreshToken: String
        public let expireDate: Date
        public let scope: String
        
        public var headers: BearerAuthorization {
            BearerAuthorization(token: accessToken)
        }
        
    }
}
