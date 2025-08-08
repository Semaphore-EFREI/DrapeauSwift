//
//  DrapTextFieldConfiguration.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 07/08/2025.
//

import SwiftUI


public struct DrapTextFieldConfiguration {
    var label: String?
    var placeholder: String?
    
    var secured: Bool = false
}



@MainActor
public enum DrapTextFieldRole {
    /// Champs de texte primaire
    case primary
    /// Champs de texte secondaire
    case secondary
}



extension EnvironmentValues {
    @Entry var drapTextFieldRole: DrapTextFieldRole = .primary
}
