//
//  ShinyOutlineModifier.swift
//  DrapeauSwift
//
//  Created by Thomas Le Bonnec on 21/06/2025.
//

import SwiftUI


struct ShinyOutlineModifier<S: InsettableShape>: ViewModifier {
    
    // MARK: Attributes
    
    @EnvironmentObject var motion: MotionManager
    
    var shape: S
    var lineWidth: CGFloat
    
    
    
    // MARK: View

    func body(content: Content) -> some View {
        content
            .padding(lineWidth) // Laisse la place pour le contour
            .background(
                shape
                    .stroke(Color.black.opacity(0.1), lineWidth: lineWidth)
            )
            .overlay(
                ShinyOutlineOverlay(shape: shape, glossAngle: motion.glossAngle, lineWidth: lineWidth)
            )
            .clipShape(shape)
    }
}

