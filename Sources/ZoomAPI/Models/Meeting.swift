//
//  Meeting.swift
//  
//
//  Created by Varun Chitturi on 12/7/22.
//

import Foundation
import Vapor

public struct MeetingInfo: Content {
    
    public enum Status: String, Content {
        case waiting, started
    }
    
    public struct Occurrence: Content {
        let duration: String
        let id: String
        let startTime: Date
        let status: String
    }
    
    // The unique identifier of the Zoom assistant associated with the meeting.
    let assistantId: String?
    // The email of the Zoom host associated with the meeting.
    let hostEmail: String?
    // The unique identifier of the Zoom host associated with the meeting.
    let hostId: String
    // The unique identifier of the Zoom meeting.
    let id: UInt64
    // The universally unique identifier (UUID) of the Zoom meeting.
    let uuid: String
    // The date and time when the Zoom meeting was created.
    let createdAt: Date
    // The URL that can be used to join the Zoom meeting.
    let joinUrl: URL
    // The occurrences of the Zoom meeting.
    let occurrences: [Occurrence]?
    // Personal Meeting ID (PMI) of the Zoom meeting.
    let pmi: String?
    // The URL that can be used to start the Zoom meeting.
    let startUrl: URL?
    // The status of the Zoom meeting.
    let status: Status?
}

public struct Meeting: Content {
    
    // The agenda of the Zoom meeting.
    var agenda: String?
    // The duration of the Zoom meeting in minutes.
    var duration: UInt64?
    // The password for the Zoom meeting.
    var password: String?
    // Whether the meeting is pre-scheduled or not.
    let preSchedule: Bool
    // The recurrence of the Zoom meeting.
    let recurrence: Recurrence?
    // The settings for the Zoom meeting.
    var settings: Settings
    // The start time of the Zoom meeting.
    var startTime: Date
    // The timezone of the Zoom meeting.
    let timezone: String
    // The topic of the Zoom meeting.
    var topic: String?
    // The tracking fields of the Zoom meeting.
    let trackingFields: [TrackingField]?
    // The type of the Zoom meeting.
    let type: MeetingType
    // The schedule for the Zoom meeting.
    let scheduleFor: String?
    // The additional information of the Zoom meeting.
    var info: MeetingInfo?
    
    init(agenda: String? = nil, duration: UInt64 = 60, password: String? = nil, preSchedule: Bool = false, recurrence: Recurrence? = nil, settings: Settings? = nil, startTime: Date? = nil, timezone: String = TimeZone.current.identifier, topic: String? = nil, trackingFields: [TrackingField]? = nil, type: Meeting.MeetingType, scheduleFor: String? = nil) {
        self.agenda = agenda
        self.duration = duration
        self.password = password
        self.preSchedule = preSchedule
        self.recurrence = recurrence
        self.settings = settings ?? Settings()
        self.startTime = startTime ?? Date.now
        self.timezone = timezone
        self.topic = topic
        self.trackingFields = trackingFields
        self.type = type
        self.scheduleFor = scheduleFor
    }
    
    public enum MeetingType: Int, Content {
        case instant = 1
        case scheduled = 2
        case recurringNoFixed = 3
        case personal = 4
        case recurringFixed = 8
    }
    
    public enum Status: String, Content {
        case scheduled, live, upcoming
        case previous = "previous_meetings"
    }
    
    struct Recurrence: Content, Equatable {
        var endTime: Date
        var endTimes: Int
        var monthlyDay: Int
        var monthlyWeek: Int
        var repeatInterval: Int
        var type: RecurrenceType
        private var weeklyDays: String
        
        var weeklyDayList: Set<WeekDay> {
            get {
                var days = Set<WeekDay>()
                weeklyDays.split(separator: ",").forEach { day in
                    if let dayNumber = Int(String(day)), let day = WeekDay.init(rawValue: dayNumber) {
                        days.insert(day)
                    }
                }
                return days
            }
            set {
                weeklyDays = Array(newValue).map({$0.rawValue.description}).joined(separator: ",")
            }
            
        }
        
        enum RecurrenceType: Int, Content {
            case daily = 1
            case weekly = 2
            case monthly = 3
        }
        
        enum WeekDay: Int, Content {
            case sunday = 1, monday = 2, tuesday = 3, wednesday = 4, thursday = 5, friday = 6, saturday = 7
        }
    }
    
    public struct Settings: Content, Equatable {
        init(allowMultipleDevices: Bool = false, alternativeHosts: [String] = [], alternativeHostsEmailNotification: Bool = true, approvalType: Meeting.Settings.ApprovalType = .manual, approvedOrDeniedCountriesOrRegions: Meeting.Settings.CountrySetting = .init(enable: false, countries: nil, method: nil), audio: Meeting.Settings.Audio = .voip, authenticationDomains: [String]? = nil, authenticationExceptions: [Meeting.Settings.AuthenticationException]? = nil, authenticationOption: String? = nil, autoRecording: Meeting.Settings.RecordingType = .none, breakoutRoom: Meeting.Settings.BreakoutRoomSetting = .init(enable: false, rooms: nil), calendarType: Meeting.Settings.CalendarType? = nil, closeRegistration: Bool = false, contactEmail: String? = nil, contactName: String? = nil, encryptionType: Meeting.Settings.EncryptionType = .enhanced, focusMode: Bool = false, globalDialInCountries: [String]? = nil, hostVideo: Bool = false, jbhTime: Int = 0, joinBeforeHost: Bool = false, languageInterpretation: Meeting.Settings.LanguageSetting? = nil, meetingAuthentication: Bool = false, meetingInvitees: [String]? = nil, muteUponEntry: Bool = false, participantVideo: Bool = false, privateMeeting: Bool = false, registrantsConfirmationEmail: Bool = true, registrantsEmailNotification: Bool = true, registrationType: Meeting.Settings.RegistrationType? = nil, showShareButton: Bool = false, usePmi: Bool = false, waitingRoom: Bool = false, watermark: Bool = false, hostSaveVideoOrder: Bool = false, alternativeHostUpdatePolls: Bool = false) {
            self.allowMultipleDevices = allowMultipleDevices
            self.alternativeHosts = alternativeHosts.joined(separator: ";")
            self.alternativeHostsEmailNotification = alternativeHostsEmailNotification
            self.approvalType = approvalType
            self.approvedOrDeniedCountriesOrRegions = approvedOrDeniedCountriesOrRegions
            self.audio = audio
            self.authenticationDomains = authenticationDomains?.joined(separator: ",")
            self.authenticationExceptions = authenticationExceptions
            self.authenticationOption = authenticationOption
            self.autoRecording = autoRecording
            self.breakoutRoom = breakoutRoom
            self.calendarType = calendarType
            self.closeRegistration = closeRegistration
            self.contactEmail = contactEmail
            self.contactName = contactName
            self.encryptionType = encryptionType
            self.focusMode = focusMode
            self.globalDialInCountries = globalDialInCountries
            self.hostVideo = hostVideo
            self.jbhTime = jbhTime
            self.joinBeforeHost = joinBeforeHost
            self.languageInterpretation = languageInterpretation
            self.meetingAuthentication = meetingAuthentication
            self.meetingInvitees = meetingInvitees
            self.muteUponEntry = muteUponEntry
            self.participantVideo = participantVideo
            self.privateMeeting = privateMeeting
            self.registrantsConfirmationEmail = registrantsConfirmationEmail
            self.registrantsEmailNotification = registrantsEmailNotification
            self.registrationType = registrationType
            self.showShareButton = showShareButton
            self.usePmi = usePmi
            self.waitingRoom = waitingRoom
            self.watermark = watermark
            self.hostSaveVideoOrder = hostSaveVideoOrder
            self.alternativeHostUpdatePolls = alternativeHostUpdatePolls
        }
         
        
        /// Whether to allow attendees to join a meeting from multiple devices. This setting is only applied to meetings with registration enabled.
        let allowMultipleDevices: Bool
        
        private let alternativeHosts: String
        
        /// List of the meeting's alternative hosts' email addresses or IDs
        var alternativeHostList: [String] {
            alternativeHosts.split(separator: ";").map({String($0)})
        }

        // Indicates whether alternative hosts will receive an email notification.
        let alternativeHostsEmailNotification: Bool
        // The approval type for the meeting.
        let approvalType: ApprovalType
        // The list of approved or denied countries or regions.
        let approvedOrDeniedCountriesOrRegions: CountrySetting
        // The audio settings for the meeting.
        let audio: Audio

        private let authenticationDomains: String?

        /// A list of the meeting's authenticated domains.
        /// - Note: Only Zoom users whose email address contains an authenticated domain can join the meeting.
        var authenticationDomainList: [String]? {
            guard let authenticationDomains else {
                return nil
            }
            return authenticationDomains.split(separator: ",").map({String($0)})
        }

        // The list of authentication exceptions for the meeting.
        var authenticationExceptions: [AuthenticationException]?
        // The authentication option for the meeting.
        var authenticationOption: String?
        // The type of auto-recording for the meeting.
        var autoRecording: RecordingType
        // The settings for breakout rooms in the meeting.
        var breakoutRoom: BreakoutRoomSetting
        // The calendar type of the meeting.
        var calendarType: CalendarType?
        // Indicates whether registration is closed or not.
        var closeRegistration: Bool
        // The contact email for the meeting.
        var contactEmail: String?
        // The contact name for the meeting.
        var contactName: String?
        // The encryption type for the meeting.
        var encryptionType: EncryptionType
        // Indicates whether focus mode is enabled or not.
        var focusMode: Bool
        // The list of global dial-in countries for the meeting.
        var globalDialInCountries: [String]?
        // Indicates whether host video is on or off.
        var hostVideo: Bool
        // The time in minutes before a meeting starts when join before host is enabled.
        var jbhTime: Int
        // Indicates whether join before host is enabled or not.
        var joinBeforeHost: Bool
        // The settings for language interpretation in the meeting.
        var languageInterpretation: LanguageSetting?
        // Indicates whether meeting authentication is enabled or not.
        var meetingAuthentication: Bool
        // The list of invitees for the meeting.
        var meetingInvitees: [String]?
        // Indicates whether participants are muted upon entry or not.
        var muteUponEntry: Bool
        // Indicates whether participant video is on or off.
        var participantVideo: Bool
        // Indicates whether the meeting is private or not.
        var privateMeeting: Bool
        // Indicates whether registrants will receive a confirmation email or not.
        var registrantsConfirmationEmail: Bool
        // Indicates whether registrants will receive email notifications or not.
        var registrantsEmailNotification: Bool
        // The type of registration for the meeting.
        var registrationType: RegistrationType?
        // Indicates whether the share button is visible or not.
        var showShareButton: Bool
        // Indicates whether Personal Meeting ID (PMI) is used or not.
        var usePmi: Bool
        // Indicates whether the waiting room feature is enabled or not.
        var waitingRoom: Bool
        // Indicates whether the watermark feature is enabled or not.
        var watermark: Bool
        // Indicates whether host can save the video order of participants.
        var hostSaveVideoOrder: Bool
        // Indicates whether alternative host can update polls
        var alternativeHostUpdatePolls: Bool
        
        public enum CalendarType: Int, Content {
            case outlook = 1, google = 2
            
        }
        
        public enum EncryptionType: String, Content {
            case enhanced = "enhanced_encryption"
            case e2ee = "e2ee"
        }
        
        public struct LanguageSetting: Content, Equatable {
            let enable: Bool
            let interpreters: [Interpreter]?
            
            struct Interpreter: Content, Equatable {
                let email: String
                let languages: String
            }
        }
        
        public struct MeetingInvitee: Content {
            let email: String
        }
        
        public enum RegistrationType: Int, Content {
            case registerOnce = 1
            case registerEach = 2
            case registerOnceAndSelect = 3
        }
        
        
        public enum ApprovalType: Int, Content {
            case automatic = 1
            case manual = 2
            case none = 3
        }
        
        public struct CountrySetting: Content, Equatable {
            let enable: Bool
            let countries: [String]?
            let method: AllowMethod?

            enum AllowMethod: String, Content {
                case allow, deny
            }
        }
        
        public enum RecordingType: String, Content {
            case local, cloud, none
        }
        
        public struct BreakoutRoomSetting: Content, Equatable {
            let enable: Bool
            let rooms: [BreakoutRoom]?
            
            struct BreakoutRoom: Content, Equatable {
                let name: String
                let participant: [String]
            }
        }
        
        public enum Audio: String, Content {
            case both, telephony, voip
        }
        
        public struct AuthenticationException: Content, Equatable {
            let email: String
            let name: String
        }
    }
    
    public struct TrackingField: Content, Equatable {
        let field: String
        let value: String
        let visible: Bool
    }
}


