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
        case .student: "Fond Semaphore Etudiant"
        case .teacher: "Fond Semaphore Enseignant"
        default: "Fond Semaphore Admin"
        }
    }
    
    var tint: Color {
        switch self {
        case .student: .drapCyan
        case .teacher: .drapPurple
        default: .drapBlue
        }
    }
}
