//
//  User.swift
//  
//
//  Created by Varun Chitturi on 1/11/23.
//

import Foundation
import Vapor

public struct User: Content {
    
    enum UserType: Int, Content {
        case basic = 1
        case licensed = 2
        case none = 99
    }
    
    enum LoginType: Int, Content {
        case facebookOAuth = 0
        case googleOAuth = 1
        case phoneNumber = 11
        case weChat = 21
        case aliPay = 23
        case appleOAuth = 24
        case microsoftOAuth = 27
        case mobileDevice = 97
        case ringCentralOAuth = 98
        case apiUser = 99
        case zoomWorkEmail = 100
        case sso = 101
    }
    
    struct PhoneNumber: Content {
        enum Label: String, Content {
            case mobile = "Mobile"
            case office = "Office"
            case home = "Home"
            case fax = "Fax"
        }
        
        let code: String
        let country: String
        let label: Label
        let number: String
        let verified: Bool
    }
    
    enum UserStatus: String, Content {
        case pending, active, inactive
    }
    
    let id: String
    let dept: String?
    let email: String
    let firstName: String?
    let lastName: String?
    let lastLoginTime: Date?
    let lastClientVersion: String?
    let pmi: Int?
    let roleName: String?
    let timezone: String?
    let type: UserType
    let usePmi: Bool
    let displayName: String
    let accountId: String?
    let accountNumber: Int?
    let company: String?
    let userCreatedAt: Date?
    let jobTitle: String?
    let language: String?
    let location: String?
    let loginTypes: [LoginType]
    let personalMeetingUrl: URL?
    let phoneNumbers: [PhoneNumber]?
    let picUrl: URL?
    let pronouns: String?
    let pronounsOption: String?
    let roleId: String?
    let status: UserStatus
    let vanityUrl: URL?
    let verified: Int
}
