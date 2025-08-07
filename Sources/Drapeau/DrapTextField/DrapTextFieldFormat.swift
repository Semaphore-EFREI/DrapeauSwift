//
//  DrapTextFieldStyle.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 07/08/2025.
//

import SwiftUI


public extension View {
    /// Définit le rôle d'un bouton.
    func drapTextFieldFormat(_ format: DrapTextFieldFormat) -> some View {
        self
            .environment(\.drapTextFieldFormat, format)
    }
}
