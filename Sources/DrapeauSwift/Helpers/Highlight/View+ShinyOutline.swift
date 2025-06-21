//
//  View+ShinyOutline.swift
//  DrapeauSwift
//
//  Created by Thomas Le Bonnec on 21/06/2025.
//

import SwiftUI

extension View {
    func shinyOutline<S: InsettableShape>(shape: S, cornerRadius: CGFloat, lineWidth: CGFloat = 1) -> some View {
        modifier(ShinyOutlineModifier(shape: shape, cornerRadius: cornerRadius, lineWidth: lineWidth))
    }
}
