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
    
    func makeBody(configuration: DrapButtonConfiguration) -> Self.Body
}





/// Style par défaut d'un DrapButton.
public struct DefaultDrapButtonStyle: DrapButtonStyle {
    
    // MARK: Attributes
    
    @Environment(\.drapButtonTint) var tint
    @Environment(\.drapButtonRole) var role
    @Environment(\.drapButtonBorderShape) var borderShape
    
    
    
    // MARK: Methods
    
    /// Méthode permettant de générer le corps du bouton. `makeBody()` est appelé par `DrapButton`.
    public func makeBody(configuration: DrapButtonConfiguration) -> some View {
        HStack(spacing: 6) {
            if let icon = configuration.icon {
                Image(systemName: icon)
                    .buttonIcon()
            }
            
            if let title = configuration.title {
                Text(title)
                    .drapButton()
            }
            
            Text("\(role)")
        }
        .foregroundStyle(foregroundColor ?? tint)
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, maxHeight: 48)
        .background(backgroundColor ?? tint)
        .roundedCorners(style: borderShape.style)
    }
    
    
    var foregroundColor: Color? {
        return switch role {
        case .primary:
            .white
        default:
            nil
        }
    }
    
    var backgroundColor: Color? {
        return switch role {
        case .secondary:
            .drapSecondaryBackground
        case .tertiary:
            .drapPrimaryBackground
        default:
            nil
        }
    }
}



/// Style condensé d'un DrapButton.
public struct CondensedDrapButtonStyle: DrapButtonStyle {
    
    // MARK: Attributes
    
    @Environment(\.drapButtonTint) var tint
    @Environment(\.drapButtonFormat) var format
    
    
    
    // MARK: Methods
    
    /// Méthode permettant de générer le corps du bouton. `makeBody()` est appelé par `DrapButton`.
    public func makeBody(configuration: DrapButtonConfiguration) -> some View {
        HStack(spacing: 6) {
            if let icon = configuration.icon {
                Image(systemName: icon)
                    .buttonIcon()
            }
            
            // Le texte ne doit être affiché que sur le bouton mini
            if format == .mini, let title = configuration.title {
                Text(title)
                    .drapButton()
            }
        }
        .foregroundStyle(tint)
        .frame(width: size?.width, height: size?.height)
        .padding(.horizontal, padding?.width)
        .padding(.vertical, padding?.height)
        .background(format == .mini ? Color.clear : Color.drapTertiaryBackground)
        .roundedCorners(style: .round)
    }
    
    
    /// Retourne la taille du bouton.
    var size: CGSize? {
        return switch format {
        case .mini:
            nil
        default:
            .init(width: 48, height: 48)
        }
    }
    
    
    /// Retourne le padding du bouton.
    var padding: CGSize? {
        return switch format {
        case .mini:
            .init(width: 10, height: 6)
        default:
            nil
        }
    }
}



/// DrapButton pour une barre d'actions.
public struct ActionBarDrapButtonStyle: DrapButtonStyle {
    
    // MARK: Attributes
    
    @Environment(\.drapButtonTint) var tint
    @Environment(\.drapButtonFormat) var format
    
    
    
    // MARK: Methods
    
    /// Méthode permettant de générer le corps du bouton. `makeBody()` est appelé par `DrapButton`.
    public func makeBody(configuration: DrapButtonConfiguration) -> some View {
        HStack(spacing: 6) {
            if let icon = configuration.icon {
                Image(systemName: icon)
                    .buttonIcon()
            }
            
            // Si le bouton est rond, il n'y a pas de texte à afficher
            if format != .circle, let title = configuration.title {
                Text(title)
                    .drapButton()
            }
        }
        .foregroundStyle(tint)
        .frame(width: size?.width, height: size?.height)
        .padding(.horizontal, padding?.width)
        .padding(.vertical, padding?.height)
        .background(format == .mini ? Color.clear : Color.drapTertiaryBackground)
        .roundedCorners(style: .round)
    }
    
    
    /// Retourne la taille du bouton.
    var size: CGSize? {
        return switch format {
        case .circle:
            .init(width: 44, height: 44)
        default:
            nil
        }
    }
    
    
    /// Retourne le padding du bouton.
    var padding: CGSize? {
        return switch format {
        case .capsule:
            .init(width: 15, height: 10)
        case .mini:
            .init(width: 10, height: 6)
        default:
            nil
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
