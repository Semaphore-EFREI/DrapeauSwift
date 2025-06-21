//
//  CourseCell.swift
//  DrapeauSwift
//
//  Created by Thomas Le Bonnec on 27/05/2025.
//

import SwiftUI
import Constants


struct CourseCell: View {
    
    // MARK: Attributes
    
    var courseTitle: String
    var description: String
    var accentColor: Color
    var icon: String
    var firstButton: (() -> DrapButton)? = nil
    var secondButton: (() -> DrapButton)? = nil
    
    
    
    // MARK: View
    
    var body: some View {
        VStack(spacing: 24) {
            courseInfoView
            buttonsView
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.drapSecondaryBackground)
        .roundedCorners(style: .large)
        .shinyOutline(shape: RoundedRectangle(cornerRadius: 32, style: .continuous))
    }
    
    
    var courseInfoView: some View {
        HStack(spacing: 24) {
            StatusDecoration(icon: icon, color: accentColor, style: .light)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(courseTitle)
                    .drapPageSubtitle()
                    .foregroundStyle(Color.drapPrimaryText)
                
                Text(description)
                    .drapDescription()
                    .foregroundStyle(accentColor)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    
    var buttonsView: some View {
        HStack(spacing: 16) {
            firstButton?()
            secondButton?()
        }
    }
}





#Preview {
    PreviewScaffold(backgroundColor: .drapPrimaryBackground) {
        CourseCell(courseTitle: "Cloud Computing Fundementals", description: "9 minutes pour signer", accentColor: .drapBlue, icon: "clock") {
            DrapButton(icon: "signature", title: "Signer") { }
        } secondButton: {
            DrapButton(icon: "cloud", title: "Suspension", style: .tertiary) { }
        }

    }
}
