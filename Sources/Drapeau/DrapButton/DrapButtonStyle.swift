//
//  DrapButtonStyle.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 05/08/2025.
//

import SwiftUI
import Constants


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

public extension DrapButtonStyle where Self == CondensedDrapButtonStyle {
    @MainActor static var condensed: Self {
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
        return DrapButton<S>(disabled: self.disabled, config: self.config, style: style, action: self.action)
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
    
    /// Définit la forme des contours d'un bouton
    func drapButtonBorderShape(_ borderShape: DrapButtonBorderShape) -> some View {
        self
            .environment(\.drapButtonBorderShape, borderShape)
    }
    
    /// Définit le format d'un bouton
    func drapButtonFormat(_ format: DrapButtonFormat) -> some View {
        self
            .environment(\.drapButtonFormat, format)
    }
}
