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
    public var title: String?
    public var disabled: Bool
    public var action: () -> Void
    
    private var style: DrapButtonStyle
    
    
    
    // MARK: Init
    
    public init(icon: String? = nil, title: String? = nil, tint: Color = .drapBlue, kind: DrapButtonStyle.DrapButtonKind = .primary, disabled: Bool = false, action: @escaping () -> Void) {
        self.icon = icon
        self.title = title
        self.disabled = disabled
        self.action = action
        self.style = DrapButtonStyle(kind: kind, tint: tint)
    }
    
    
    
    // MARK: Views
    
    public var body: some View {
        Button {
            action()
        } label: {
            buttonContent
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
            
            if let title {
                Text(title)
                    .drapButton()
            }
        }
        .foregroundStyle(style.parameters.foregroundColor)
        .padding(.horizontal, style.parameters.horizontalPadding)
        .padding(.vertical, style.parameters.verticalPadding)
        .frame(maxWidth: style.parameters.maxWidth, minHeight: style.parameters.minHeight)
        .background(style.parameters.backgroundColor)
        .roundedCorners(style: style.parameters.cornerStyle)
        .buttonShadow(activated: style.parameters.shadow)
        .conditionnalGlass(cornerStyle: style.parameters.cornerStyle, activated: style.kind == .small)
    }
    
    
    
    // MARK: Internal Objects
    
    public struct DrapButtonStyle {
        
        // MARK: Attributes
        
        public let kind: DrapButtonKind
        public let tint: Color
        
        
        var parameters: DrapButtonParameters {
            return switch self.kind {
            case .primary:
                DrapButtonParameters(
                    backgroundColor: tint,
                    foregroundColor: .drapInverseText
                )
            case .secondary:
                DrapButtonParameters(
                    backgroundColor: .drapSecondaryBackground,
                    foregroundColor: tint
                )
            case .tertiary:
                DrapButtonParameters(
                    backgroundColor: .drapPrimaryBackground,
                    foregroundColor: tint
                )
            case .primaryRounded:
                DrapButtonParameters(
                    backgroundColor: tint,
                    foregroundColor: .drapInverseText,
                    cornerStyle: .medium
                )
            case .secondaryRounded:
                DrapButtonParameters(
                    backgroundColor: .drapSecondaryBackground,
                    foregroundColor: tint,
                    cornerStyle: .medium
                )
            case .small:
                if #available(iOS 26.0, *) {
                    DrapButtonParameters(
                        backgroundColor: .clear,
                        foregroundColor: tint,
                        horizontalPadding: 16,
                        verticalPadding: 10,
                        maxWidth: .none,
                        minHeight: 44,
                        cornerStyle: .round
                    )
                } else {
                    DrapButtonParameters(
                        backgroundColor: .drapSecondaryBackground,
                        foregroundColor: tint,
                        shadow: true,
                        horizontalPadding: 12,
                        verticalPadding: 6,
                        maxWidth: .none,
                        minHeight: 34
                    )
                }
            case .secondarySmall:
                DrapButtonParameters(
                    backgroundColor: .clear,
                    foregroundColor: tint,
                    horizontalPadding: 0,
                    verticalPadding: 6,
                    maxWidth: .none,
                    minHeight: 34
                )
            }
        }
        
        
        // MARK: Init
        
        public init(kind: DrapButtonKind, tint: Color) {
            self.kind = kind
            self.tint = tint
        }
        
        
        // MARK: Inner Objects
        
        public enum DrapButtonKind {
            case primary
            case secondary
            case tertiary
            case primaryRounded
            case secondaryRounded
            case small
            case secondarySmall
        }
        
        struct DrapButtonParameters {
            var backgroundColor: Color
            var foregroundColor: Color
            var shadow: Bool = false
            var horizontalPadding: CGFloat = 20
            var verticalPadding: CGFloat = 12
            var maxWidth: CGFloat? = .infinity
            var minHeight: CGFloat = 46
            var cornerStyle: RoundedCornersStyle = .regular
        }
    }
}





#Preview {
    PreviewScaffold(backgroundColor: .drapQuaternaryBackground) {
        VStack(spacing: 24) {
            DrapButton(icon: "signature", title: "Hello") {}
            DrapButton(icon: "signature", title: "Hello", kind: .secondary) {}
            DrapButton(icon: "signature", title: "Hello", kind: .tertiary) {}
            DrapButton(icon: "signature", title: "Hello", kind: .primaryRounded) {}
            DrapButton(icon: "signature", title: "Hello", kind: .secondaryRounded) {}
            DrapButton(icon: "signature", title: "Hello", kind: .small) {}
            DrapButton(icon: "signature", title: "Hello", kind: .secondarySmall) {}
        }
    }
}
