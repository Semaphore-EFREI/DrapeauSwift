//
//  DefaultDrapButtonStyle.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 06/08/2025.
//

import SwiftUI
import Styles


/// Style par défaut d'un DrapButton.
public struct DefaultDrapButtonStyle: DrapButtonStyle {
    
    // MARK: - Methods
    
    /// Méthode permettant de générer le corps du bouton. `makeBody()` est appelé par `DrapButton`.
    public func makeBody(configuration: DrapButtonConfiguration) -> some View {
        DefaultDrapButton(configuration: configuration)
    }
    
    
    
    // MARK: - View
    
    fileprivate struct DefaultDrapButton: View {
        
        // MARK: Attributes
        
        @Environment(\.drapButtonTint) var tint
        @Environment(\.drapButtonRole) var role
        @Environment(\.drapButtonFormat) var format
        @Environment(\.drapButtonExpand) var expand
        
        let configuration: DrapButtonConfiguration
        
        
        
        // MARK: View
        
        var body: some View {
            HStack(alignment: .center, spacing: 6) {
                if let icon = configuration.icon {
                    Image(systemName: icon)
                        .buttonIcon()
                }
                
                if let title = configuration.title {
                    Text(title)
                        .drapButton()
                }
            }
            .foregroundStyle(foregroundColor ?? tint)
            .padding(.horizontal, padding.width)
            .padding(.vertical, padding.height)
            .frame(minWidth: minSize?.width, minHeight: minSize?.height, alignment: .center)
            .frame(maxWidth: expand ? .infinity : nil)
            .conditionalBackground(cornersStyle: cornersStyle, liquidBackgroundColor: backgroundColor ?? tint, backgroundColor: backgroundColor ?? tint, showGlassEffect: showGlassEffect)
        }
        
        
        
        // MARK: Computed Properties
        
        /// Retourne la couleur de fond à appliquer sur le bouton. Nil indique qu'il faut utiliser la teinte du bouton.
        var backgroundColor: Color? {
            if format == .simple { return .clear }
            return switch role {
            case .primary:
                nil
            case .secondary:
                .drapSecondaryBackground
            case .tertiary:
                .drapTertiaryBackground
            }
        }
        
        /// Retourne la couleur de face à appliquer sur le bouton. Nil indique qu'il faut utiliser la teinte du bouton.
        var foregroundColor: Color? {
            return switch role {
            case .primary:
                .white
            default:
                nil
            }
        }
        
        
        /// Retourne l'espacement autour du contenu du bouton s'il y en a.
        var padding: CGSize {
            return switch format {
            case .standard, .capsule:
                if configuration.title != nil {
                    .init(width: 20, height: 13)
                } else {
                    .init(width: 0, height: 0)
                }
            default:
                .init(width: 20, height: 13)
            }
        }
        
        
        /// Retourne les dimensions minimales du bouton s'il y en a.
        var minSize: CGSize? {
            return switch format {
            case .standard, .capsule:
                .init(width: 48, height: 48)
            default:
                nil
            }
        }
        
        
        var cornersStyle: RoundedCornersStyle {
            return switch format {
            case .standard:
                if #available(iOS 26.0, macOS 26.0, *) {
                    .round
                } else {
                    .regular
                }
            default:
                .round
            }
        }
        
        
        var showGlassEffect: Bool {
            // Vérification de la possibilité d'afficher l'effet selon le type de bouton
            var show = false
            switch format {
            case .simple:
                show = false
            default:
                show = true
            }
            
            // Si glassEffect est sur faux dans la configuration, alors l'effet ne sera pas affiché
            guard configuration.glassEffect else { return false }
            return show
        }
    }
}

