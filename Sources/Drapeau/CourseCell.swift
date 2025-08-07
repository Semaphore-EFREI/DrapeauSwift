//
//  CourseCell.swift
//  DrapeauSwift
//
//  Created by Thomas Le Bonnec on 27/05/2025.
//

import SwiftUI
import Styles


/*
public struct CourseCell: View {
    
    // MARK: Attributes
    
    public var courseTitle: String
    public var description: String
    public var accentColor: Color
    public var icon: String
    public var firstButton: (() -> DrapButton)? = nil
    public var secondButton: (() -> DrapButton)? = nil
    
    
    
    // MARK: Init
    
    public init(courseTitle: String, description: String, accentColor: Color, icon: String, firstButton: (() -> DrapButton)? = nil, secondButton: (() -> DrapButton)? = nil) {
        self.courseTitle = courseTitle
        self.description = description
        self.accentColor = accentColor
        self.icon = icon
        self.firstButton = firstButton
        self.secondButton = secondButton
    }
    
    
    
    // MARK: View
    
    public var body: some View {
        VStack(spacing: 24) {
            courseInfoView
            if firstButton != nil || secondButton != nil {
                buttonsView
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.drapPrimaryBackground)
        .roundedCorners(style: .large)
        //.drapReflect(cornersStyle: .large, reflectStyle: .secondary)
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
            DrapButton(icon: "cloud", title: "Suspension") { }
        }
    }
}
*/
