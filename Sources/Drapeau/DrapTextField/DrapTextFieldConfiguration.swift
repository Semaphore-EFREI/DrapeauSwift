//
//  DrapTextFieldConfiguration.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 07/08/2025.
//

import SwiftUI


@MainActor
public enum DrapTextFieldFormat {
    /// Champs de texte avec coins
    case regular
    /// Champs de texte en capsule
    case capsule
}



extension EnvironmentValues {
    @Entry var drapTextFieldFormat: DrapTextFieldFormat = .regular
}
