//
//  Reflects.swift
//  DrapeauSwift
//
//  Created by Thomas Le Bonnec on 22/06/2025.
//

import SwiftUI


public extension View {
    func drapReflect(cornersStyle: RoundedCornersStyle, reflectStyle: ReflectStyle) -> some View {
        if #available(iOS 26.0, *) {
            return self
                .glassEffect(in: .rect(cornerRadius: cornersStyle.rawValue, style: .continuous))
        } else {
            return self
                .secondaryShadow()
                .overlay {
                    RoundedRectangle(cornerRadius: cornersStyle.rawValue, style: .continuous)
                        .stroke(Color.black.opacity(reflectStyle.rawValue), lineWidth: 1)
                }
        }
    }
    
    
    func drapReflectWithUnevenCorners(cornersStyle: RoundedCornersStyle? = nil, topLeading: CGFloat? = nil, topTrailing: CGFloat? = nil, bottomLeading: CGFloat? = nil, bottomTrailing: CGFloat? = nil, reflectStyle: ReflectStyle) -> some View {
        if #available(iOS 26.0, *) {
            let topLeadingRadius = topLeading ?? cornersStyle?.rawValue ?? 0.0
            let topTrailingRadius = topTrailing ?? cornersStyle?.rawValue ?? 0.0
            let bottomLeadingRadius = bottomLeading ?? cornersStyle?.rawValue ?? 0.0
            let bottomTrailingRadius = bottomTrailing ?? cornersStyle?.rawValue ?? 0.0
            return self
                .glassEffect(in: .rect(topLeadingRadius: topLeadingRadius, bottomLeadingRadius: bottomLeadingRadius, bottomTrailingRadius: bottomTrailingRadius, topTrailingRadius: topTrailingRadius, style: .continuous))
        } else {
            return self
                .secondaryShadow()
                .overlay {
                    RoundedRectangle(cornerRadius: cornersStyle?.rawValue ?? 0.0, style: .continuous)
                        .stroke(Color.black.opacity(reflectStyle.rawValue), lineWidth: 1)
                }
        }
    }
    
    
    func conditionnalGlass(cornerStyle: RoundedCornersStyle, activated: Bool = true) -> some View {
        if #available(iOS 26.0, *) {
            return self
                .glassEffect(in: .rect(cornerRadius: cornerStyle.rawValue, style: .continuous), isEnabled: activated)
        } else {
            return self
        }
    }
}



public enum ReflectStyle: Double {
    case primary = 0.24
    case secondary = 0.07
}
