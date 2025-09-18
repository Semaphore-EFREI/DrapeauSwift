//
//  CourseCard.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 18/09/2025.
//

import SwiftUI
import Styles

public struct CourseCard: View {
    
    // MARK: Attributes
    
    var bundle: Bundle
    var status: CourseStatus
    
    
    
    // MARK: Init
    
    public init(status: CourseStatus) {
        self.bundle = .main
        self.status = status
    }
    
    /// Uniquement pour les prévisualisations
    /// Mettre bundle = ProjectBundle.module
    init(bundle: Bundle, status: CourseStatus) {
        self.bundle = bundle
        self.status = status
    }
    
    
    
    // MARK: View
    
    public var body: some View {
        VStack(spacing: 16) {
            topView
            PointsLine(size: .medium)
            detailView
        }
        .padding(24)
        .background(Color.drapTertiaryBackground)
        .roundedCorners(style: .extraLarge, borderStyle: .secondary)
    }
    
    
    var topView: some View {
        HStack(spacing: 13) {   // Devrait être 16, mais l'ombre du sceau inclu dans l'image doit être soustraite (valeur de 10/3)
            Image(status.sealImage, bundle: bundle)     // TODO: Enlever l'ombre des PNG, et les appliquer dans le code
                .resizable()
                .scaledToFit()
                .frame(width: 169/3, height: 169/3)
                .offset(x: -1, y: -1)   // L'ombre étant inclue dans le png, elle augmente la taille du sceau sur les bords (3 en haut et à gauche, 10 en bas et à droite (valeurs pour 169x169))
            
            VStack(alignment: .leading, spacing: 8) {
                notificationsView
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("De l'atome à la puce")
                        .drapPageSubtitle()
                    
                    timeAndPlaceView
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    
    var notificationsView: some View {
        HStack(spacing: 12) {
            CourseNotification(role: .now)
                .foregroundStyle(status.accentColor)
            CourseNotification(role: .message)
        }
    }
    
    
    var timeAndPlaceView: some View {
        HStack(spacing: 20) {
            Text("8h00 - 10h10")
            
            HStack(spacing: 4) {
                Image(systemName: "mappin.and.ellipse")
                    .font(.footnote)
                Text("H116")
            }
        }
        .drapBody()
        .foregroundStyle(Color.drapSecondaryText)
    }
    
    
    var detailView: some View {
        VStack(spacing: 16) {
            Image(systemName: status.humanSymbol ?? "rectangle")
                .font(.system(size: 64))
                .foregroundStyle(Color.drapQuaternaryText)
                .opacity(0.24)
            
            Text(status.description ?? "9 minutes pour signer")
                .drapDescription()
                .foregroundStyle(status.accentColor)
                .multilineTextAlignment(.center)
        }
        .frame(height: 150)
    }
}





#Preview {
    PreviewScaffold(backgroundColor: .drapPrimaryBackground) {
        CourseCard(bundle: ProjectBundle.module, status: .now)
            .activeCourseCardShadow()
    }
}
