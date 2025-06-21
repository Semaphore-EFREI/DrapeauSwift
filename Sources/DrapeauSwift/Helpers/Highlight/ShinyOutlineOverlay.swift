//
//  ShinyOutlineOverlay.swift
//  DrapeauSwift
//
//  Created by Thomas Le Bonnec on 20/06/2025.
//

import SwiftUI


struct ShinyOutlineOverlay<S>: View where S: InsettableShape {
    
    // MARK: Attributes
    
    var shape: S
    var glossAngle: Angle // Angle du reflet, dynamique ou statique
    var lineWidth: CGFloat = 4
    
    
    
    // MARK: View
    
    var body: some View {
        shape
            .stroke(
                AngularGradient(
                    gradient: Gradient(stops: [
                        .init(color: .white.opacity(0.8), location: 0.0),
                        .init(color: .white.opacity(0.0), location: 0.18),
                        .init(color: .white.opacity(0.0), location: 0.82),
                        .init(color: .white.opacity(0.8), location: 1.0)
                    ]),
                    center: .center,
                    angle: glossAngle
                ),
                lineWidth: lineWidth
            )
            //.blendMode(.screen)
            .allowsHitTesting(false)
    }
}
