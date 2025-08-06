//
//  DefaultDrapButtonStyle.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 06/08/2025.
//

import SwiftUI


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
        @Environment(\.drapButtonBorderShape) var borderShape
        
        let configuration: DrapButtonConfiguration
        
        
        // MARK: View
        
        var body: some View {
            HStack(spacing: 6) {
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
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, maxHeight: 48)
            .background(backgroundColor ?? tint)
            .roundedCorners(style: borderShape.cornersStyle)
        }
        
        
        // MARK: Methods
        
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
}

