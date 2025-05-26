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
}



public enum RoundedCornersStyle: CGFloat {
    case regular = 8
    case large = 12
}
