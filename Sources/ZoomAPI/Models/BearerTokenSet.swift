//
//  BearerTokenSet.swift
//  
//
//  Created by Varun Chitturi on 12/4/22.
//

import Foundation

extension ZoomClient {
    public struct BearerTokenSet {
        let accessToken: String
        let refreshToken: String
        let expireDate: Date
        let scope: String
    }
}
