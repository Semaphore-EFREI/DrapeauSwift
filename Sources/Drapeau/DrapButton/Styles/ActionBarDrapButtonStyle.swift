//
//  ActionBarDrapButtonStyle.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 06/08/2025.
//

import SwiftUI
import Styles


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
                if let title = configuration.title {
                    Text(title)
                        .drapButton()
                }
            }
            .foregroundStyle(tint)
            .padding(.horizontal, padding.width)
            .padding(.vertical, padding.height)
            .frame(minWidth: minSize?.width, minHeight: minSize?.height)
            .conditionalBackground(cornersStyle: .round, backgroundColor: backgroundColor, showGlassEffect: showGlassEffect)
        }
        
        
        // MARK: Computed Properties
        
        /// Retourne la taille du bouton.
        var minSize: CGSize? {
            return switch format {
            case .capsule:
                .init(width: 44, height: 44)
            default:
                nil
            }
        }
        
        
        /// Retourne le padding du bouton.
        var padding: CGSize {
            return switch format {
            case .capsule:
                if configuration.title != nil {
                    .init(width: 15, height: 13)
                } else {
                    .init(width: 10, height: 6)
                }
            default:
                .init(width: 10, height: 6)
            }
        }
        
        
        /// Définit le fond à appliquer selon plusieurs critères
        var backgroundColor: Color? {
            return switch format {
            case .capsule:
                if #available(iOS 26.0, macOS 26.0, *) {
                    nil
                } else {
                    .drapTertiaryBackground
                }
            default:
                nil
            }
        }
        
        
        /// Décide pour iOS 26.0 + s'il faut ou non afficher le verre
        var showGlassEffect: Bool {
            return switch format {
            case .capsule:
                true
            default:
                false
            }
        }
    }
}
