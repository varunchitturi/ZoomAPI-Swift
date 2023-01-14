//
//  User.swift
//  
//
//  Created by Varun Chitturi on 1/11/23.
//

import Foundation
import Vapor

public struct UserInfo: Content {
    let email: String
    let firstName: String?
    let lastName: String?
    let displayName: String?
    let password: String
    let type: User.UserType
}

public struct User: Content {
    
    public enum UserType: Int, Content {
        case basic = 1
        case licensed = 2
        case none = 99
    }
    
    public enum LoginType: Int, Content {
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
    
    public struct PhoneNumber: Content {
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
    
    public enum Status: String, Content {
        case pending, active, inactive
    }
    
    let id: String
    var dept: String?
    var email: String
    var firstName: String?
    var lastName: String?
    let lastLoginTime: Date?
    let lastClientVersion: String?
    let pmi: Int?
    var roleName: String?
    let timezone: String?
    var type: UserType
    var usePmi: Bool?
    var displayName: String
    let accountId: String?
    let accountNumber: Int?
    let company: String?
    let userCreatedAt: Date?
    var jobTitle: String?
    let language: String?
    let location: String?
    let loginTypes: [LoginType]?
    let personalMeetingUrl: URL?
    var phoneNumbers: [PhoneNumber]?
    let picUrl: URL?
    var pronouns: String?
    var pronounsOption: PronounDisplayOption?
    let roleId: String?
    let status: Status
    let vanityUrl: URL?
    let verified: Int
}

public enum UserCreateAction: String, Content {
    /// The user receives an email from Zoom containing a confirmation link. The user must then use the link to activate their Zoom account. The user can then set or change their password.
    case create
    /// This action is for Enterprise customers with a managed domain. This feature is disabled by default because of the security risk involved in creating a user who does not belong to your domain.
    case autoCreate
    /// Users created with this action do not have passwords and will not have the ability to log into the Zoom web portal or the Zoom client. These users can still host and join meetings using the start_url and join_url respectively. To use this option, you must contact the Integrated Software Vendor (ISV) sales team.
    case custCreate
    /// This action is provided for the enabled “Pre-provisioning SSO User” option. A user created this way has no password. If it is not a Basic user, a personal vanity URL with the username (no domain) of the provisioning email is generated. If the username or PMI is invalid or occupied, it uses a random number or random personal vanity URL.
    case ssoCreate
}

public enum UserDeleteAction: String, Content {
    /// Disassociating a user unlinks the user from the associated Zoom account and provides the user their own basic free Zoom account. The disassociated user can then purchase their own Zoom licenses. An account owner or account admin can transfer the user's meetings, webinars, and cloud recordings to another user before disassociation.
    /// - Note: To delete pending user in the account, use disassociate
    case disassociate
    /// Deleting a user permanently removes the user and their data from Zoom. Users can create a new Zoom account using the same email address. An account owner or an account admin can transfer meetings, webinars and cloud recordings to another Zoom user account before deleting.
    case delete
}

public enum PronounDisplayOption: Int, Content {
    /// Ask the user every time they join meetings and webinars.
    case ask = 1
    /// Always display pronouns in meetings and webinars.
    case always = 2
    /// Do not display pronouns in meetings and webinars.
    case noDisplay = 3
}
