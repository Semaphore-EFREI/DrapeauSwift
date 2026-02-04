//
//  CourseViewInfos.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 18/09/2025.
//

import SwiftUI

public class CourseViewInfos {
    public var name: String
    public var status: CourseStatus
    public var startDate: Date
    public var endDate: Date
    public var place: String
    public var signatureEndDate: Date
    public var hasMessages: Bool
    public var signature: [CGVector]
    
    public init(name: String, status: CourseStatus, startDate: Date, endDate: Date, place: String, signatureEndDate: Date, hasMessages: Bool, signature: [CGVector]) {
        self.name = name
        self.status = status
        self.startDate = startDate
        self.endDate = endDate
        self.place = place
        self.signatureEndDate = signatureEndDate
        self.hasMessages = hasMessages
        self.signature = signature
    }
}
