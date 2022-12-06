//
//  BearerTokenSet.swift
//  
//
//  Created by Varun Chitturi on 12/4/22.
//

import Foundation

extension ZoomClient {
    public struct BearerTokenSet {
        public let accessToken: String
        public let refreshToken: String
        public let expireDate: Date
        public let scope: String
    }
}
