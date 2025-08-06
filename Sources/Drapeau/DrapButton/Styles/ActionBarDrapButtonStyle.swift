//
//  ActionBarDrapButtonStyle.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 06/08/2025.
//

import SwiftUI


/// DrapButton pour une barre d'actions.
public struct ActionBarDrapButtonStyle: DrapButtonStyle {
    
    // MARK: Methods
    
    /// Méthode permettant de générer le corps du bouton. `makeBody()` est appelé par `DrapButton`.
    public func makeBody(configuration: DrapButtonConfiguration) -> some View {
        ActionBarDrapButton(configuration: configuration)
    }
    
    
    
    // MARK: - View
    
    fileprivate struct ActionBarDrapButton: View {
        
        // MARK: Attributes
        
        @Environment(\.drapButtonTint) var tint
        @Environment(\.drapButtonFormat) var format
        
        let configuration: DrapButtonConfiguration
        
        
        // MARK: View
        
        var body: some View {
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
            .padding(.horizontal, padding?.width)
            .padding(.vertical, padding?.height)
            .frame(width: size?.width, height: size?.height)
            .background(format == .mini ? Color.clear : Color.drapTertiaryBackground)
            .roundedCorners(style: .round)
        }
        
        
        // MARK: Methods
        
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
}
