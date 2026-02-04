//
//  SettingsPage.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 03/02/2026.
//

import SwiftUI
import Styles


public struct SettingsPage: View {
    
    // MARK: Attributes
    
    @EnvironmentObject var metrics: ScreenMetrics
    
    var name: String
    var pseudo: String
    var userRole: UserRole
    var deviceLinkedToOtherDevice: Bool
    var deviceLock: Int?                // En minutes
    var closePage: () -> Void
    var disconnectAction: () -> Void
    
    
    // MARK: Init
    
    public init(name: String, pseudo: String, userRole: UserRole, deviceLinkedToOtherDevice: Bool, deviceLock: Int? = nil, closePage: @escaping () -> Void, disconnectAction: @escaping () -> Void) {
        self.name = name
        self.pseudo = pseudo
        self.userRole = userRole
        self.deviceLinkedToOtherDevice = deviceLinkedToOtherDevice
        self.deviceLock = deviceLock
        self.closePage = closePage
        self.disconnectAction = disconnectAction
    }
    
    
    // MARK: View
    
    public var body: some View {
        ZStack {
            Image(userRole.image, bundle: ProjectBundle.module)
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity)
                .clipped()
                .ignoresSafeArea()
            
            ZStack(alignment: .top) {
                userCard
                    .offset(y: -150)
                
                mainFrame
            }
            .padding(11)
            .padding(.top, 200)
            .ignoresSafeArea(edges: .bottom)
        }
    }
    
    
    var mainFrame: some View {
        let cornerRadius = metrics.borderRadius - 11
        
        return VStack {
            ContextToolbar(items: .constant([
                ErasedContextToolbarItem(id: UUID(), placement: .leading, makeBody: {
                    AnyView(
                        DrapButton(icon: "xmark") {
                            closePage()
                        }
                        .style(.actionBar)
                    )
                })
            ]), titleConfig: ContextToolbarTitleConfiguration(title: "Paramètres"))
            
            if userRole == .student {
                content
            }
            
            Spacer()
            
            VStack(spacing: 16) {
                Text("Version 1.0")
                    .drapDescription()
                    .foregroundStyle(userRole.tint)
                
                DrapButton(icon: "iphone.and.arrow.right.outward", title: "Se Déconnecter") {
                    disconnectAction()
                }
                .drapButtonExpand()
                .drapButtonRole(.tertiary)
                .drapButtonTint(.drapPrimaryText)
            }
            .padding(cornerRadius - 24)
        }
        .frame(maxWidth: .infinity)
        .conditionalBackground(cornersStyle: .extraLarge, interactive: false)
        .unevenRoundedCorners(style: .extraLarge, bottomTrailing: cornerRadius, bottomLeading: cornerRadius)
    }
    
    
    
    var userCard: some View {
        VStack(spacing: 14) {
            // Profile Picture
            ZStack {
                userRole.tint
                    .frame(width: 54, height: 54)
                    .roundedCorners(style: .round)
                
                Text("MD")
                    .drapPageTitle()
                    .foregroundStyle(Color.white)
            }
            
            Text("Marc DUPONT")
                .drapPageTitle()
            
            Spacer()
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .frame(height: 400)
        .background(Color.drapTertiaryBackground)
        .roundedCorners(style: .extraLarge)
        .padding(.horizontal, 38)
    }
    
    
    var content: some View {
        VStack(spacing: 16) {
            if !deviceLinkedToOtherDevice {
                if let deviceLock {
                    Image(systemName: "lock.iphone")
                        .font(.system(size: 96))
                    
                    Text("Votre appareil a été lié à votre compte récemment. Vous devez attendre pour changer d'appareil.")
                        .multilineTextAlignment(.center)
                        .drapBody()
                    
                    Text(formatDuration(minutes: deviceLock))
                        .drapPageTitle()
                        .foregroundStyle(userRole.tint)
                } else {
                    Image(systemName: "lock.open.iphone")
                        .font(.system(size: 96))
                        .foregroundStyle(userRole.tint)
                    
                    Text("Votre compte peut être lié à un autre appareil si besoin.")
                        .multilineTextAlignment(.center)
                        .drapBody()
                }
            } else {
                Image(systemName: "iphone.gen3.slash")
                    .font(.system(size: 96))
                    .foregroundStyle(userRole.tint)
                
                Text("Votre compte est relié à un autre appareil. Vous ne pourrez pas signer depuis celui-ci")
                    .multilineTextAlignment(.center)
                    .drapBody()
            }
        }
        .padding(24)
        .frame(maxHeight: .infinity)
    }
    
    
    
    // MARK: Methods
    
    func formatDuration(minutes: Int) -> String {
        precondition(minutes >= 0, "La durée ne peut pas être négative")

        switch minutes {
        case let m where m >= 1440:
            let days = m / 1440
            return "J - \(days)"

        case let m where m >= 60:
            let hours = m / 60
            return "H - \(hours)H"

        default:
            return "H - \(minutes)min"
        }
    }
}





#Preview {
    PreviewScaffold(disablePadding: true) {
        SettingsPage(name: "Marc DUPONT", pseudo: "MD", userRole: .teacher, deviceLinkedToOtherDevice: true, deviceLock: nil) {
            print("")
        } disconnectAction: {
            print("")
        }
    }
}
