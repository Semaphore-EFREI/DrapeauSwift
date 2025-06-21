//
//  Shadows.swift
//  DrapeauSwift
//
//  Created by Thomas Le Bonnec on 27/05/2025.
//

import SwiftUI


public extension View {
    func drapShadow() -> some View {
        self.shadow(color: Color(hue: 0, saturation: 0, brightness: 0, opacity: 0.12), radius: 16)
    }
}
