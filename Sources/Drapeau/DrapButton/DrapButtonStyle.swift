//
//  DrapButtonStyle.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 05/08/2025.
//

import SwiftUI
import Styles


@MainActor public protocol DrapButtonStyle {
    associatedtype Body: View
    
    @ViewBuilder @MainActor func makeBody(configuration: DrapButtonConfiguration) -> Self.Body
}


public extension DrapButtonStyle where Self == DefaultDrapButtonStyle {
    @MainActor static var `default`: Self {
        get {
            return Self()
        }
    }
}

public extension DrapButtonStyle where Self == ActionBarDrapButtonStyle {
    @MainActor static var actionBar: Self {
        get {
            return Self()
        }
    }
}




public extension DrapButton {
    /// Désactive l'effet de verre sur le bouton
    /// - Requires: iOS 26+ / macOS 26+
    func disableGlassEffect() -> Self {
        var copy = self
        copy.config.glassEffect = false
        return copy
    }
    
    
    /// Change le style d'un bouton.
    func style<S: DrapButtonStyle>(_ style: S) -> DrapButton<S> {
        return DrapButton<S>(config: self.config, style: style)
    }
}



public extension View {
    /// Définit le rôle d'un bouton.
    func drapButtonRole(_ role: DrapButtonRole) -> some View {
        self
            .environment(\.drapButtonRole, role)
    }
    
    /// Définit la teinte d'un bouton.
    func drapButtonTint(_ tint: Color) -> some View {
        self
            .environment(\.drapButtonTint, tint)
    }
    
    /// Définit le format d'un bouton
    func drapButtonFormat(_ format: DrapButtonFormat) -> some View {
        self
            .environment(\.drapButtonFormat, format)
    }
    
    
    func drapButtonExpand(_ expand: Bool) -> some View {
        self
            .environment(\.drapButtonExpand, expand)
    }
}
