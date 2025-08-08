//
//  DrapTextFieldStyle.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 07/08/2025.
//

import SwiftUI


@MainActor public protocol DrapTextFieldStyle {
    associatedtype Body: View
    
    @ViewBuilder @MainActor func makeBody(configuration: DrapTextFieldConfiguration, value: Binding<String>) -> Self.Body
}


public extension DrapTextFieldStyle where Self == InlineDrapTextFieldStyle {
    @MainActor static var inline: Self {
        get {
            return Self()
        }
    }
}

public extension DrapTextFieldStyle where Self == MultilineDrapTextFieldStyle {
    @MainActor static var multiline: Self {
        get {
            return Self()
        }
    }
}




public extension DrapTextField {
    /// Change le style d'un champs de texte.
    func style<S: DrapTextFieldStyle>(_ style: S) -> DrapTextField<S> {
        return DrapTextField<S>(value: self.$value, configuration: self.configuration, style: style)
    }
}



public extension View {
    /// Définit le rôle d'un bouton.
    func drapTextFieldRole(_ role: DrapTextFieldRole) -> some View {
        self
            .environment(\.drapTextFieldRole, role)
    }
}
