//
//  CourseViewInfos.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 18/09/2025.
//

import SwiftUI

public class CourseViewInfos {
    @Binding var name: String
    @Binding var status: CourseStatus
    @Binding var startDate: Date
    @Binding var endDate: Date
    @Binding var place: String
    @Binding var signatureEndDate: Date
    @Binding var hasMessages: Bool
    @Binding var signature: [CGVector]
    
    
    public init(name: Binding<String>, status: Binding<CourseStatus>, startDate: Binding<Date>, endDate: Binding<Date>, place: Binding<String>, signatureEndDate: Binding<Date>, hasMessages: Binding<Bool>, signature: Binding<[CGVector]>) {
        self._name = name
        self._status = status
        self._startDate = startDate
        self._endDate = endDate
        self._place = place
        self._signatureEndDate = signatureEndDate
        self._hasMessages = hasMessages
        self._signature = signature
    }
}
