//
//  Borders.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 01/08/2025.
//

import SwiftUI


public extension View {
    func primaryBorder() -> some View {
        self
            .overlay {
                RoundedRectangle(cornerRadius: cornersStyle.rawValue, style: .continuous)
                    .stroke(Color.black.opacity(reflectStyle.rawValue), lineWidth: 1)
            }
    }
}
