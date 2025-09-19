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
    var infos: CourseViewInfos
    
    
    
    
    // MARK: Init
    
    public init(infos: CourseViewInfos) {
        self.bundle = .main
        self.infos = infos
    }
    
    /// Uniquement pour les prévisualisations
    /// Mettre bundle = ProjectBundle.module
    public init(bundle: Bundle, infos: CourseViewInfos) {
        self.bundle = bundle
        self.infos = infos
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
            Image(infos.status.sealImage, bundle: bundle)     // TODO: Enlever l'ombre des PNG, et les appliquer dans le code
                .resizable()
                .scaledToFit()
                .frame(width: 169/3, height: 169/3)
                .offset(x: -1, y: -1)   // L'ombre étant inclue dans le png, elle augmente la taille du sceau sur les bords (3 en haut et à gauche, 10 en bas et à droite (valeurs pour 169x169))
            
            VStack(alignment: .leading, spacing: 8) {
                notificationsView
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(infos.name)
                        .drapPageSubtitle()
                    
                    timeAndPlaceView
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    
    var notificationsView: some View {
        HStack(spacing: 12) {
            if Date().isBetween(infos.startDate, and: infos.endDate) {
                CourseNotification(role: .now)
                    .foregroundStyle(infos.status.accentColor)
            }
            if infos.hasMessages {
                CourseNotification(role: .message)
            }
        }
    }
    
    
    var timeAndPlaceView: some View {
        HStack(spacing: 20) {
            Text("\(infos.startDate.time) - \(infos.endDate.time)")
            
            HStack(spacing: 4) {
                Image(systemName: "mappin.and.ellipse")
                    .font(.footnote)
                Text(infos.place)
            }
        }
        .drapBody()
        .foregroundStyle(Color.drapSecondaryText)
    }
    
    
    var detailView: some View {
        VStack(spacing: 16) {
            Image(systemName: infos.status.humanSymbol ?? "rectangle")
                .font(.system(size: 64))
                .foregroundStyle(Color.drapQuaternaryText)
                .opacity(0.24)
            
            Text(infos.status.description ?? remainingTimeToSign)
                .drapDescription()
                .foregroundStyle(infos.status.accentColor)
                .multilineTextAlignment(.center)
        }
        .frame(height: 150)
    }
    
    
    
    // MARK: Computed Properties
    
    var remainingTimeToSign: String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full      // "2 hours, 5 minutes"
        formatter.maximumUnitCount = 2    // Seulement l’unité la plus significative
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth, .month, .year]
        formatter.calendar = Calendar.current
        formatter.collapsesLargestUnit = true
        formatter.includesApproximationPhrase = false
        formatter.includesTimeRemainingPhrase = false
        formatter.zeroFormattingBehavior = .dropAll
        formatter.calendar?.locale = .current

        if let time = formatter.string(from: infos.startDate, to: infos.signatureEndDate) {
            return "\(time) pour signer"
        }
        return "Temps écoulé"
    }
}





#Preview {
    PreviewScaffold(backgroundColor: .drapPrimaryBackground) {
        CourseCard(
            bundle: ProjectBundle.module,
            infos:
                CourseViewInfos(
                    name: .constant("De l'Atome à la Puce"),
                    status: .constant(.now),
                    startDate: .constant(Date(timeIntervalSince1970: Date().timeIntervalSince1970 - 600)),
                    endDate: .constant(Date(timeIntervalSince1970: Date().timeIntervalSince1970 + 2400)),
                    place: .constant("H116"),
                    signatureEndDate: .constant(Date(timeIntervalSince1970: Date().timeIntervalSince1970 + 540)),
                    hasMessages: .constant(false),
                    signature: .constant([])
                )
        )
        .activeCourseCardShadow()
    }
}
