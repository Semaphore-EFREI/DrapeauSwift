//
//  DrapButton.swift
//  DrapeauSwift
//
//  Created by Thomas Le Bonnec on 26/05/2025.
//

import SwiftUI
import Constants


public struct DrapButton: View {
    
    // MARK: Attributes
    
    public var icon: String?
    public var title: String
    public var style: DrapButtonStyle = .primary
    public var disabled: Bool = false
    public var action: () -> Void
    
    
    
    // MARK: Views
    
    public var body: some View {
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
        .disabled(disabled)
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
    
    public enum DrapButtonStyle {
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
                    cornerStyle: .medium
                )
            case .secondaryRounded:
                DrapButtonParameters(
                    backgroundColor: .drapSecondaryBackground,
                    foregroundColor: .drapBlue,
                    cornerStyle: .medium
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
    
    
    public struct DrapButtonParameters {
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
