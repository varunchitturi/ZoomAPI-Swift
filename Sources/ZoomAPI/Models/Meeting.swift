//
//  File.swift
//  
//
//  Created by Varun Chitturi on 12/7/22.
//

import Foundation
import Vapor

struct Meeting: Content {
    enum Status: String {
        case scheduled
        case live
        case upcoming
        case previous
    }
    enum MeetingType: Int, Codable {
        case instant = 1
        case scheduled = 2
        case recurringNoFixed = 3
        case recurringFixed = 8
    }
    
    let agenda: String
    let createdAt: Date
    let duration: Int
    let hostID: String
    let id: String
    let joinURL: URL
    let pmi: String?
    let startTime: Date
    let timezone: String
    let topic: String
    let type: MeetingType
    let uuid: String
    
    
}
