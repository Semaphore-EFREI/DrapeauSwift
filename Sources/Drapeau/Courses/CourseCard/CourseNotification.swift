//
//  CourseNotification.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 08/08/2025.
//

import SwiftUI


/// Affiche une notification sous forme de badge pour avertir l'utilisateur d'un élément important à propos du cours.
public struct CourseNotification: View {
    
    // MARK: Attributes
    
    var role: Role
    
    
    
    // MARK: Init
    
    public init(role: Role) {
        self.role = role
    }
    
    
    
    // MARK: View
    
    public var body: some View {
        Group {
            switch role {
            case .now:
                nowView
            case .message:
                messageView
            }
        }
    }
    
    
    var nowView: some View {
        HStack(spacing: 6) {
            Image(systemName: "circle.fill")
                .descriptionIcon()
            
            Text("EN COURS")
                .drapImportantDescription()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.drapSecondaryBackground)
        .roundedCorners(style: .round)
    }
    
    
    var messageView: some View {
        Image(systemName: "envelope.fill")
            .descriptionIcon()
            .frame(width: 28, height: 28)
            .foregroundStyle(Color.drapBlue)
            .background(Color.drapSecondaryBackground)
            .roundedCorners(style: .round)
    }
    
    
    
    // MARK: Inner Objects
    
    public enum Role {
        /// Affiche la notification "EN COURS".
        /// - Note: Il est possible de modifier la couleur avec .foregroundStyle().
        case now
        /// Affiche la notification message.
        /// - Note: Il n'est pas possible de modifier la couleur.
        case message
    }
}





#Preview {
    PreviewScaffold(backgroundColor: .drapPrimaryBackground) {
        CourseNotification(role: .message)
            .foregroundStyle(Color.drapBlue)
    }
}
