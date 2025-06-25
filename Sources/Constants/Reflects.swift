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
}



public enum ReflectStyle: Double {
    case primary = 0.24
    case secondary = 0.1
}
