//
//  DrapButtonConfiguration.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 05/08/2025.
//

import SwiftUI
import Styles


public struct DrapButtonConfiguration {
    var title: String?
    var icon: String?
    
    // iOS 26 +
    var glassEffect: Bool = true
}





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
    /// Bouton en forme de capsule
    case capsule
    /// Bouton en forme de cercle
    case circle
    /// Bouton en sans fond
    case simple
}





extension EnvironmentValues {
    @Entry var drapButtonRole: DrapButtonRole = .primary
    @Entry var drapButtonFormat: DrapButtonFormat = .standard
    @Entry var drapButtonTint: Color = .drapBlue
    @Entry var drapButtonExpand: Bool = false
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




