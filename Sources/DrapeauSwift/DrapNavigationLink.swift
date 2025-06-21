//
//  DrapNavigationLink.swift
//  DrapeauSwift
//
//  Created by Thomas Le Bonnec on 27/05/2025.
//

import SwiftUI


struct DrapNavigationLink: View {
    
    // MARK: Attributes
    
    var title: String
    var icon: String
    var value: String?
    var isSelected: Bool = false
    
    
    
    // MARK: Views
    
    var body: some View {
        HStack {
            leftView
            
            Spacer()
            
            rightView
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 14)
        .background(isSelected ? Color.drapTertiaryBackground : Color.clear)
        .roundedCorners(style: .regular)
    }
    
    
    var leftView: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .bodyIcon()
            
            Text(title)
                .drapImportantBody()
        }
        .foregroundStyle(Color.drapPrimaryText)
    }
    
    
    var rightView: some View {
        HStack(spacing: 8) {
            if let value {
                Text(value)
                    .drapBody()
            }
            
            Image(systemName: "chevron.right")
                .bodyIcon()
        }
        .foregroundStyle(Color.drapSecondaryText)
    }
}





#Preview {
    PreviewScaffold {
        DrapNavigationLink(title: "Informations Utilisateur", icon: "person.fill", value: "100%", isSelected: true)
    }
}
