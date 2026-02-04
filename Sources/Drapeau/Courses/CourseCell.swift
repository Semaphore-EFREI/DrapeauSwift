//
//  CourseCell.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 18/09/2025.
//

import SwiftUI


public struct CourseCell: View {
    
    // MARK: Attributes
    
    var infos: CourseViewInfos
    
    
    
    // MARK: Init
    
    public init(infos: CourseViewInfos) {
        self.infos = infos
    }
    
    
    
    // MARK: View
    
    public var body: some View {
        HStack(spacing: 16) {
            statusIndicator
            courseInfos
            Spacer()
            if infos.hasMessages {
                messageIndicator
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(isNow ? infos.status.accentColor.opacity(0.1) : Color.clear)
        .roundedCorners(style: .regular)
    }
    
    
    var statusIndicator: some View {
        Circle()
            .foregroundStyle(infos.status.accentColor)
            .frame(width: 12, height: 12)
    }
    
    
    var courseInfos: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(infos.name)
                .drapImportantBody()
                .foregroundStyle(Color.drapPrimaryText)
            
            Text("\(infos.startDate.time) - \(infos.endDate.time)   \(infos.place)")
                .drapBody()
                .foregroundStyle(Color.drapSecondaryText)
        }
    }
    
    
    var messageIndicator: some View {
        Image(systemName: "envelope.fill")
            .foregroundStyle(Color.drapBlue)
    }
    
    
    
    // MARK: Computed Properties
    
    var isNow: Bool {
        Date().isBetween(infos.startDate, and: infos.endDate)
    }
}





#Preview {
    PreviewScaffold {
        CourseCell(
            infos:
                CourseViewInfos(
                    name: "De l'Atome à la Puce",
                    status: .now,
                    startDate: Date(timeIntervalSince1970: Date().timeIntervalSince1970 - 600),
                    endDate: Date(timeIntervalSince1970: Date().timeIntervalSince1970 + 2400),
                    place: "H116",
                    signatureEndDate: Date(timeIntervalSince1970: Date().timeIntervalSince1970 + 540),
                    hasMessages: false,
                    signature: ""
                )
        )
    }
}
