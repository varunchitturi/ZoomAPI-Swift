//
//  Meeting.swift
//  
//
//  Created by Varun Chitturi on 12/7/22.
//

import Foundation
import Vapor

public struct MeetingInfo: Content {
    
    internal init(assistantId: String? = nil, hostEmail: String? = nil, hostId: String, id: UInt64, uuid: String, createdAt: Date, joinUrl: URL, occurrences: [MeetingInfo.Occurrence]? = nil, pmi: String? = nil, startUrl: URL? = nil, status: MeetingInfo.Status? = nil) {
        self.assistantId = assistantId
        self.hostEmail = hostEmail
        self.hostId = hostId
        self.id = id
        self.uuid = uuid
        self.createdAt = createdAt
        self.joinUrl = joinUrl
        self.occurrences = occurrences
        self.pmi = pmi
        self.startUrl = startUrl
        self.status = status
    }
    

    
    public enum Status: String, Content {
        case waiting, started
    }
    
    public struct Occurrence: Content {
        let duration: String
        let id: String
        let startTime: String
        let status: String
    }
    
    let assistantId: String?
    let hostEmail: String?
    let hostId: String
    let id: UInt64
    let uuid: String
    let createdAt: Date
    let joinUrl: URL
    let occurrences: [Occurrence]?
    let pmi: String?
    let startUrl: URL?
    let status: Status?
}

public struct Meeting: Content {
    
    var agenda: String?
    var duration: UInt64?
    var password: String?
    let preSchedule: Bool
    let recurrence: Recurrence?
    var settings: Settings
    var startTime: Date
    let timezone: String
    var topic: String?
    let trackingFields: [TrackingField]?
    let type: MeetingType
    let scheduleFor: String?
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
        
        var alternativeHostList: [String] {
            alternativeHosts.split(separator: ";").map({String($0)})
        }

        let alternativeHostsEmailNotification: Bool
        let approvalType: ApprovalType
        let approvedOrDeniedCountriesOrRegions: CountrySetting
        let audio: Audio

        private let authenticationDomains: String?

        var authenticationDomainList: [String]? {
            guard let authenticationDomains else {
                return nil
            }
            return authenticationDomains.split(separator: ",").map({String($0)})
        }

        var authenticationExceptions: [AuthenticationException]?
        var authenticationOption: String?
        var autoRecording: RecordingType
        var breakoutRoom: BreakoutRoomSetting
        var calendarType: CalendarType?
        var closeRegistration: Bool
        var contactEmail: String?
        var contactName: String?
        var encryptionType: EncryptionType
        var focusMode: Bool
        var globalDialInCountries: [String]?
        var hostVideo: Bool
        var jbhTime: Int
        var joinBeforeHost: Bool
        var languageInterpretation: LanguageSetting?
        var meetingAuthentication: Bool
        var meetingInvitees: [String]?
        var muteUponEntry: Bool
        var participantVideo: Bool
        var privateMeeting: Bool
        var registrantsConfirmationEmail: Bool
        var registrantsEmailNotification: Bool
        var registrationType: RegistrationType?
        var showShareButton: Bool
        var usePmi: Bool
        var waitingRoom: Bool
        var watermark: Bool
        var hostSaveVideoOrder: Bool
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


