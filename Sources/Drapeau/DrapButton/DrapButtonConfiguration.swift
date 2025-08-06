//
//  DrapButtonConfiguration.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 05/08/2025.
//

import SwiftUI
import Constants


public struct DrapButtonConfiguration {
    var title: String?
    var icon: String?
    
    // iOS 26 +
    var glassEffect: Bool = false
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


/// Style n'ayant d'effet que sur iOS 18 - (iOS 26 + ayant capsule dans tous les cas).
@MainActor
public enum DrapButtonBorderShape {
    /// Coins légèrements arrondis (n'a aucun effet sur iOS 26 +)
    case regular
    /// Coins ronds
    case rounded
    
    
    var style: RoundedCornersStyle {
        return switch self {
        case .regular:
            .regular
        case .rounded:
            .round
        }
    }
}


@MainActor
public enum DrapButtonFormat {
    /// Bouton en forme de capsule
    case capsule
    /// Bouton en forme de cercle
    case circle
    /// Bouton simple sans fond
    case mini
}





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


struct DrapButtonBorderShapeKey: EnvironmentKey {
    static let defaultValue: DrapButtonBorderShape = .regular
}

extension EnvironmentValues {
    public var drapButtonBorderShape: DrapButtonBorderShape {
        get {
            self[DrapButtonBorderShapeKey.self]
        } set {
            self[DrapButtonBorderShapeKey.self] = newValue
        }
    }
}


struct DrapButtonFormatKey: EnvironmentKey {
    static let defaultValue: DrapButtonFormat = .capsule
}

extension EnvironmentValues {
    public var drapButtonFormat: DrapButtonFormat {
        get {
            self[DrapButtonFormatKey.self]
        } set {
            self[DrapButtonFormatKey.self] = newValue
        }
    }
}


struct DrapButtonTintKey: EnvironmentKey {
    static let defaultValue: Color = .drapBlue
}

extension EnvironmentValues {
    public var drapButtonTint: Color {
        get {
            self[DrapButtonTintKey.self]
        } set {
            self[DrapButtonTintKey.self] = newValue
        }
    }
}


