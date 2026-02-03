//
//  File.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 03/02/2026.
//

import SwiftUI


public enum UserRole {
    case student, teacher, admin
    
    var image: String {
        switch self {
        case .student: "Fond Sémaphore Étudiant"
        case .teacher: "Fond Sémaphore Enseignant"
        default: "Fond Sémaphore Admin"
        }
    }
    
    var tint: Color {
        switch self {
        case .student: .drapGreen
        case .teacher: .drapPurple
        default: .drapBlue
        }
    }
}
