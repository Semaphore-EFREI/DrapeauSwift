//
//  DrapButton.swift
//  DrapeauSwift
//
//  Created by Thomas Le Bonnec on 26/05/2025.
//

import SwiftUI
import Constants


struct DrapButton: View {
    
    // MARK: Attributes
    
    var icon: String?
    var title: String
    var style: DrapButtonStyle = .primary
    var action: () -> Void
    
    
    
    // MARK: Views
    
    var body: some View {
        Button {
            action()
        } label: {
            buttonContent
                .foregroundStyle(style.parameters.foregroundColor)
                .padding(.horizontal, style.parameters.horizontalPadding)
                .padding(.vertical, style.parameters.verticalPadding)
                .frame(maxWidth: style.parameters.maxWidth, minHeight: style.parameters.minHeight)
                .background(style.parameters.backgroundColor)
                .roundedCorners(style: style.parameters.cornerStyle)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    
    var buttonContent: some View {
        HStack(spacing: 6) {
            if let icon {
                Image(systemName: icon)
                    .buttonIcon()
            }
            
            Text(title)
                .drapButton()
        }
    }
    
    
    
    // MARK: Internal Objects
    
    enum DrapButtonStyle {
        case primary
        case secondary
        case tertiary
        case primaryRounded
        case secondaryRounded
        case small
        case secondarySmall
        
        
        var parameters: DrapButtonParameters {
            return switch self {
            case .primary:
                DrapButtonParameters(
                    backgroundColor: .drapBlue,
                    foregroundColor: .drapInverseText
                )
            case .secondary:
                DrapButtonParameters(
                    backgroundColor: .drapSecondaryBackground,
                    foregroundColor: .drapBlue
                )
            case .tertiary:
                DrapButtonParameters(
                    backgroundColor: .drapPrimaryBackground,
                    foregroundColor: .drapBlue
                )
            case .primaryRounded:
                DrapButtonParameters(
                    backgroundColor: .drapBlue,
                    foregroundColor: .drapInverseText,
                    cornerStyle: .large
                )
            case .secondaryRounded:
                DrapButtonParameters(
                    backgroundColor: .drapSecondaryBackground,
                    foregroundColor: .drapBlue,
                    cornerStyle: .large
                )
            case .small:
                DrapButtonParameters(
                    backgroundColor: .drapSecondaryBackground,
                    foregroundColor: .drapBlue,
                    horizontalPadding: 12,
                    verticalPadding: 6,
                    maxWidth: .none,
                    minHeight: 34
                )
            case .secondarySmall:
                DrapButtonParameters(
                    backgroundColor: .clear,
                    foregroundColor: .drapBlue,
                    horizontalPadding: 0,
                    verticalPadding: 6,
                    maxWidth: .none,
                    minHeight: 34
                )
            }
        }
    }
    
    
    struct DrapButtonParameters {
        var backgroundColor: Color
        var foregroundColor: Color
        var horizontalPadding: CGFloat = 20
        var verticalPadding: CGFloat = 12
        var maxWidth: CGFloat? = .infinity
        var minHeight: CGFloat = 46
        var cornerStyle: RoundedCornersStyle = .regular
    }
}





#Preview {
    PreviewScaffold {
        DrapButton(icon: "signature", title: "Hello") {
            
        }
    }
}
