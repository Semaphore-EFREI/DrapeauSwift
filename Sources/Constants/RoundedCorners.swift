//
//  RoundedCorners.swift
//  DrapeauSwift
//
//  Created by Thomas Le Bonnec on 26/05/2025.
//

import SwiftUI


public extension View {
    func roundedCorners(style: RoundedCornersStyle) -> some View {
        self
            .clipShape(.rect(cornerRadius: style.rawValue, style: .continuous))
    }
    
    
    func roundedCornersWithBorder(style: RoundedCornersStyle, strokeColor: Color) -> some View {
        self
            .roundedCorners(style: style)
            .overlay {
                RoundedRectangle(cornerRadius: style.rawValue, style: .continuous)
                    .stroke(strokeColor, lineWidth: 1)
            }
    }
    
    
    func customRoundedCorners(radius: CGFloat) -> some View {
        self
            .clipShape(.rect(cornerRadius: radius, style: .continuous))
    }
    
    
    func customRoundedCornersWithBorder(radius: CGFloat, strokeWidth: CGFloat, strokeColor: Color) -> some View {
        self
            .customRoundedCorners(radius: radius)
            .overlay {
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .stroke(strokeColor, lineWidth: strokeWidth)
            }
    }
    
    
    func unevenRoundedCorners(topLeading: CGFloat, topTrailing: CGFloat, bottomTrailing: CGFloat, bottomLeading: CGFloat) -> some View {
        self
            .clipShape(.rect(topLeadingRadius: topLeading, bottomLeadingRadius: bottomLeading, bottomTrailingRadius: bottomTrailing, topTrailingRadius: topTrailing, style: .continuous))
    }
}



public enum RoundedCornersStyle: CGFloat {
    case regular = 16
    case medium = 23
    case large = 32
    case extraLarge = 38
    case round = 1000        // Valeur excessive pour que les coins soient ronds peu importe la hauteur de l'élément
}
