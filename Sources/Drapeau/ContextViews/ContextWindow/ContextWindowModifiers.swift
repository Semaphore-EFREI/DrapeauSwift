//
//  ContextWindowModifiers.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 21/08/2025.
//

import SwiftUI


public extension ContextWindow {
    func style(_ style: Style) -> Self {
        var copy = self
        copy.contentStyle = style
        return copy
    }
}



public extension View {
    func contextWindowDescription() -> some View {
        self
            .drapDescription()
            .foregroundStyle(Color.drapPrimaryText)
            .multilineTextAlignment(.center)
            .padding(.bottom, 13)          // Padding de 29 (mais espacement de 16 déjà présent)
    }
}
