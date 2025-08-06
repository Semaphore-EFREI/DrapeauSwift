//
//  RoundedCorners.swift
//  DrapeauSwift
//
//  Created by Thomas Le Bonnec on 26/05/2025.
//

import SwiftUI


public extension View {
    /// Arrondit les angles de façon continue, avec un contour optionnel, de taille variable.
    private func roundedCorners(radius: CGFloat, borderColor: Color = .clear, borderWidth: CGFloat = 1) -> some View {
        self
            .clipShape(.rect(cornerRadius: radius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .stroke(borderColor, lineWidth: borderWidth)
            }
    }
    
    
    /// Arrondit les angles selon le style spécifié.
    func roundedCorners(style: RoundedCornersStyle, borderStyle: BorderStyle? = nil) -> some View {
        let borderColor = borderStyle != nil ? Color.black.opacity(borderStyle!.rawValue) : Color.clear
        return self
            .roundedCorners(radius: style.rawValue, borderColor: borderColor)
    }
    
    
    /// Arrondit les angles de façon irrégulière, avec contour optionnel et taille variable.
    ///
    /// - Requires: iOS 16+ / macOS 13+
    @available(iOS 16.0, macOS 13.0, *)
    private func unevenRoundedCorners(topLeading: CGFloat, topTrailing: CGFloat, bottomTrailing: CGFloat, bottomLeading: CGFloat, borderColor: Color = .clear, borderWidth: CGFloat = 1) -> some View {
        self
            .clipShape(
                .rect(
                    topLeadingRadius: topLeading,
                    bottomLeadingRadius: bottomLeading,
                    bottomTrailingRadius: bottomTrailing,
                    topTrailingRadius: topTrailing,
                    style: .continuous
                )
            )
            .overlay {
                UnevenRoundedRectangle(
                    topLeadingRadius: topLeading,
                    bottomLeadingRadius: bottomLeading,
                    bottomTrailingRadius: bottomTrailing,
                    topTrailingRadius: topTrailing,
                    style: .continuous
                )
            }
    }
    
    
    /// Arrondit les angles selon le style spécifié.
    ///
    /// - Requires: iOS 16+ / macOS 13+
    @available(iOS 16.0, macOS 13.0, *)
    func unevenRoundedCorners(style: RoundedCornersStyle, topLeading: CGFloat? = nil, topTrailing: CGFloat? = nil, bottomTrailing: CGFloat? = nil, bottomLeading: CGFloat? = nil, borderStyle: BorderStyle? = nil) -> some View {
        let borderColor = borderStyle != nil ? Color.black.opacity(borderStyle!.rawValue) : Color.clear
        return self
            .unevenRoundedCorners(
                topLeading: topLeading ?? style.rawValue,
                topTrailing: topTrailing ?? style.rawValue,
                bottomTrailing: bottomTrailing ?? style.rawValue,
                bottomLeading: bottomLeading ?? style.rawValue,
                borderColor: borderColor
            )
    }
}





/// Valeurs fixes pour l'arrondi des coins
public enum RoundedCornersStyle: CGFloat {
    case regular = 16
    case medium = 23
    case large = 32
    case extraLarge = 38
    case round = 1000        // Valeur excessive pour que les coins soient ronds peu importe la taille de l'élément
}



/// Valeurs fixes pour l'opacité des coins
public enum BorderStyle: Double {
    case primary = 0.24
    case secondary = 0.8
}
