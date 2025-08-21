//
//  DrapButtonModifiers.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 21/08/2025.
//

import SwiftUI


/// Style pour `DefaultDrapButtonStyle` uniquement.
@MainActor
public enum DrapButtonRole {
    /// Bouton de haute importance
    case primary
    /// Bouton de moindre importance, à placer sur fond primaire
    case secondary
    /// Bouton de moindre importance, à placer sur fond secondaire
    case tertiary
}


@MainActor
public enum DrapButtonFormat {
    /// Bouton avec des coins légèrements arrondis
    case standard
    /// Bouton en forme de capsule ou cercle
    case capsule
    /// Bouton en sans fond
    case simple
}





extension EnvironmentValues {
    @Entry var drapButtonRole: DrapButtonRole = .primary
    @Entry var drapButtonFormat: DrapButtonFormat = .standard
    @Entry var drapButtonTint: Color = .drapBlue
    @Entry var drapButtonExpand: Bool = false
}




public extension DrapButton {
    /// Désactive l'effet de verre sur le bouton
    /// - Requires: iOS 26+ / macOS 26+
    func disableGlassEffect() -> Self {
        var copy = self
        copy.config.glassEffect = false
        return copy
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
    
    
    func drapButtonExpand() -> some View {
        self
            .environment(\.drapButtonExpand, true)
    }
}





/*
// Ancienne structure
 
struct DrapButtonRoleKey: EnvironmentKey {
    static let defaultValue: DrapButtonRole = .primary
}

extension EnvironmentValues {
    public var drapButtonRole: DrapButtonRole {
        get {
            self[DrapButtonRoleKey.self]
        } set {
            self[DrapButtonRoleKey.self] = newValue
        }
    }
}
*/
