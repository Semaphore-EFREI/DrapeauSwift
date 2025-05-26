//
//  RoundedCorners.swift
//  DrapeauSwift
//
//  Created by Thomas Le Bonnec on 26/05/2025.
//

import SwiftUI


public extension View {
    func roundedCorners(style: RoundedCornersStyle) -> some View {
        self.clipShape(.rect(cornerRadius: style.rawValue, style: .continuous))
    }
}


public enum RoundedCornersStyle: CGFloat {
    case regular = 8
    case large = 12
}
