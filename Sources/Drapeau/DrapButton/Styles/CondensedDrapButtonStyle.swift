//
//  CondensedDrapButtonStyle.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 06/08/2025.
//

import SwiftUI


/// Style condensé d'un DrapButton.
public struct CondensedDrapButtonStyle: DrapButtonStyle {
    
    // MARK: - Methods
    
    /// Méthode permettant de générer le corps du bouton. `makeBody()` est appelé par `DrapButton`.
    public func makeBody(configuration: DrapButtonConfiguration) -> some View {
        CondensedDrapButton(configuration: configuration)
    }
    
    
    
    // MARK: - View
    
    fileprivate struct CondensedDrapButton: View {
        
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
                
                // Le texte ne doit être affiché que sur le bouton mini
                if format == .mini, let title = configuration.title {
                    Text(title)
                        .drapButton()
                }
            }
            .foregroundStyle(tint)
            .frame(width: size?.width, height: size?.height)
            .padding(.horizontal, padding.width)
            .padding(.vertical, padding.height)
            .background(format == .mini ? Color.clear : Color.drapTertiaryBackground)
            .roundedCorners(style: .round)
        }
        
        
        // MARK: Methods
        
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
        var padding: CGSize {
            return switch format {
            case .mini:
                .init(width: 10, height: 6)
            default:
                .init(width: 0, height: 0)
            }
        }
    }
}

