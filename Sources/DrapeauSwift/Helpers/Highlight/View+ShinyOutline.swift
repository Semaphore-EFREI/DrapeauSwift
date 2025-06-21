//
//  View+ShinyOutline.swift
//  DrapeauSwift
//
//  Created by Thomas Le Bonnec on 21/06/2025.
//

import SwiftUI

extension View {
    func shinyOutline<S: InsettableShape>(shape: S, lineWidth: CGFloat = 1) -> some View {
        modifier(ShinyOutlineModifier(shape: shape, lineWidth: lineWidth))
    }
}
