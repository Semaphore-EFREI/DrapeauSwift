//
//  Shadows.swift
//  DrapeauSwift
//
//  Created by Thomas Le Bonnec on 27/05/2025.
//

import SwiftUI


public extension View {
    func primaryShadow() -> some View {
        self.shadow(color: Color(hue: 0, saturation: 0, brightness: 0, opacity: 0.32), radius: 16)
    }
    
    func secondaryShadow() -> some View {
        self.shadow(color: Color(hue: 0, saturation: 0, brightness: 0, opacity: 0.06), radius: 24)
    }
    
    func buttonShadow(activated: Bool = true) -> some View {
        self.shadow(color: Color(hue: 0, saturation: 0, brightness: 0, opacity: activated ? 0.24 : 0.0), radius: 12)
    }

    func courseCardShadow() -> some View {
        self.shadow(color: Color(hue: 0, saturation: 0, brightness: 0, opacity: 0.06), radius: 8, y: 4)
    }
    
    func activeCourseCardShadow() -> some View {
        self
            .shadow(color: .black.opacity(0.04), radius: 4, y: 4)
            .shadow(color: .black.opacity(0.08), radius: 8, y: 8)
    }
}
