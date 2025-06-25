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
        self.shadow(color: Color(hue: 0, saturation: 0, brightness: 0, opacity: 0.06), radius: 16)
    }
    
    func buttonShadow(activated: Bool = true) -> some View {
        self.shadow(color: Color(hue: 0, saturation: 0, brightness: 0, opacity: activated ? 0.24 : 0.0), radius: 12)
    }
}
