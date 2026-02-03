//
//  LoginPage.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 03/02/2026.
//

import SwiftUI
import Styles


public struct LoginPage: View {
    
    // MARK: Attributes
    
    @Binding var mail: String
    @Binding var password: String
    var userRole: UserRole
    var action: () -> Void
    
    
    // MARK: Init
    
    public init(mail: Binding<String>, password: Binding<String>, userRole: UserRole, action: @escaping () -> Void) {
        self._mail = mail
        self._password = password
        self.userRole = userRole
        self.action = action
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
            
            content
                .padding(24)
        }
    }
    
    
    var content: some View {
        VStack(spacing: 36) {
            Text("Sémaphore")
                .drapPageTitle()
            
            VStack(spacing: 24) {
                DrapTextField(label: "Identifiant", placeholder: "etudiant@semaphore.com", value: $mail)
                DrapTextField(label: "Mot de passe", placeholder: "••••••••••••", value: $password, secured: true)
            }
            
            DrapButton(title: "Se connecter", disabled: mail == "" || password == "") {
                print()
            }
            .drapButtonExpand()
            .drapButtonTint(userRole.tint)
        }
        .padding([.horizontal, .bottom], 14)
        .padding(.top, 32)
        .conditionalBackground(cornersStyle: .extraLarge, interactive: false)
    }
}




#Preview {
    @Previewable @State var mail: String = ""
    @Previewable @State var password: String = ""
    
    PreviewScaffold(disablePadding: true) {
        LoginPage(mail: $mail, password: $password, userRole: .teacher) {
            print("")
        }
    }
}
