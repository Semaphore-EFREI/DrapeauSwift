//
//  CourseStatus.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 18/09/2025.
//

import SwiftUI


public enum CourseStatus {
    case now, late, present, presentToken, absent, later, error
    
    var accentColor: Color {
        return switch self {
        case .now: .drapBlue
        case .late: .drapOrange
        case .present: .drapGreen
        case .presentToken: .drapCyan
        case .absent: .drapRed
        case .later: .drapGray
        case .error: .drapBrown
        }
    }
    
    
    var sealImage: String {
        return switch self {
        case .now: "Sceau En Cours"
        case .late: "Sceau Retard"
        case .present: "Sceau Presence"
        case .presentToken: "Sceau Jeton Presence"
        case .absent: "Sceau Absent"
        case .later: "Sceau Plus Tard"
        case .error: "Sceau Erreur"
        }
    }
    
    
    var humanSymbol: String? {
        return switch self {
        case .now: "figure.walk"
        case .late: "figure.run"
        case .present: nil
        case .presentToken: "figure.wave"
        case .absent: "figure.fall"
        case .later: "figure.fishing"
        case .error: "figure.climbing"
        }
    }
    
    
    var description: String? {
        return switch self {
        case .now: nil
        case .late: "Vous êtes en retard"
        case .present: "Vous êtes présent !"
        case .presentToken: "Vous avez été mis présent"
        case .absent: "Malheur ! Vous êtes absent !"
        case .later: "Ce cours a lieu plus tard"
        case .error: "Oups, une erreur est survenue. On fait remonter !"
        }
    }
}
