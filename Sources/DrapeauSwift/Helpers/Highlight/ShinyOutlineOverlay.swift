//
//  ShinyOutlineOverlay.swift
//  DrapeauSwift
//
//  Created by Thomas Le Bonnec on 20/06/2025.
//

import SwiftUI


struct ShinyOutlineOverlay<S>: View where S: InsettableShape {
    
    // MARK: Attributes
    
    @State var gradientValues: [GradientValue] = []
    
    var shape: S
    var cornerRadius: CGFloat
    @Binding var angle: Double // Angle du reflet, dynamique ou statique
    var lineWidth: CGFloat = 4
    
    
    
    // MARK: View
    
    var body: some View {
        GeometryReader { geo in
            shape
                .stroke(
                    AngularGradient(
                        gradient: Gradient(stops: [
                            .init(color: .white.opacity(gradientValues.indices.contains(0) ? gradientValues[0].intensity : 0.0), location: gradientValues.indices.contains(0) ? gradientValues[0].position : 0.0),
                            .init(color: .white.opacity(gradientValues.indices.contains(1) ? gradientValues[1].intensity : 0.0), location: gradientValues.indices.contains(1) ? gradientValues[1].position : 0.0),
                            .init(color: .white.opacity(gradientValues.indices.contains(2) ? gradientValues[2].intensity : 0.0), location: gradientValues.indices.contains(2) ? gradientValues[2].position : 0.0),
                            .init(color: .white.opacity(gradientValues.indices.contains(3) ? gradientValues[3].intensity : 0.0), location: gradientValues.indices.contains(3) ? gradientValues[3].position : 0.0)
                        ]),
                        center: .center
                    ),
                    lineWidth: lineWidth
                )
            //.blendMode(.screen)
                .allowsHitTesting(false)
                .onChange(of: angle) { oldValue, newValue in
                    gradientValues = highlightZonesForRoundedRect(width: geo.size.width, height: geo.size.height, cornerRadius: cornerRadius, lightAngleDegrees: newValue)
                    print(gradientValues)
                }
        }
    }
    
    
    
    // MARK: Méthods
    
    /// Donne la normale locale au contour d’un RoundedRectangle (dans le sens horaire, t ∈ [0,1])
    func roundedRectNormal(t: Double, width: CGFloat, height: CGFloat, radius: CGFloat) -> CGVector {
        // Périmètre total
        let w = width
        let h = height
        let r = min(radius, min(width, height)/2)
        let arcLength = .pi/2 * r
        let sideLengthW = w - 2*r
        let sideLengthH = h - 2*r
        let perim = 2*(sideLengthW + sideLengthH) + 4*arcLength

        // Sections :
        // 1: coin haut gauche (0..arc)
        // 2: haut (arc..arc+sideW)
        // 3: coin haut droit (arc+sideW..arc*2+sideW)
        // 4: côté droit (arc*2+sideW..arc*2+sideW+sideH)
        // 5: coin bas droit
        // 6: bas
        // 7: coin bas gauche
        // 8: côté gauche

        let d = t * perim

        // Sections (ordre : coin, côté, coin, côté, ...)
        if d < arcLength {
            // Coin haut gauche, de 180° à 270°
            let frac = d / arcLength
            let angle = .pi + frac * (.pi/2)
            return CGVector(dx: cos(angle), dy: sin(angle))
        }
        else if d < arcLength + sideLengthW {
            // Haut, normale vers le haut
            return CGVector(dx: 0, dy: -1)
        }
        else if d < arcLength*2 + sideLengthW {
            // Coin haut droit, de 270° à 360°
            let frac = (d - arcLength - sideLengthW) / arcLength
            let angle = 1.5 * .pi + frac * (.pi/2)
            return CGVector(dx: cos(angle), dy: sin(angle))
        }
        else if d < arcLength*2 + sideLengthW + sideLengthH {
            // Droite, normale vers la droite
            return CGVector(dx: 1, dy: 0)
        }
        else if d < arcLength*3 + sideLengthW + sideLengthH {
            // Coin bas droit, de 0° à 90°
            let frac = (d - arcLength*2 - sideLengthW - sideLengthH) / arcLength
            let angle = 0.0 + frac * (.pi/2)
            return CGVector(dx: cos(angle), dy: sin(angle))
        }
        else if d < arcLength*3 + sideLengthW*2 + sideLengthH {
            // Bas, normale vers le bas
            return CGVector(dx: 0, dy: 1)
        }
        else if d < arcLength*4 + sideLengthW*2 + sideLengthH {
            // Coin bas gauche, de 90° à 180°
            let frac = (d - arcLength*3 - sideLengthW*2 - sideLengthH) / arcLength
            let angle = .pi/2 + frac * (.pi/2)
            return CGVector(dx: cos(angle), dy: sin(angle))
        }
        else {
            // Gauche, normale vers la gauche
            return CGVector(dx: -1, dy: 0)
        }
    }
    
    
    /// Calcule les bornes x, y, a, b à utiliser dans un Gradient pour l’effet de highlight réel
    func highlightZonesForRoundedRect(width: CGFloat,
                                     height: CGFloat,
                                     cornerRadius: CGFloat,
                                     lightAngleDegrees: Double,
                                     samples: Int = 400,
                                     highlightThreshold: Double = 0.95,
                                     shadowThreshold: Double = 0.05) -> [GradientValue] {

        let lightAngle = lightAngleDegrees * .pi / 180
        let lightDir = CGVector(dx: cos(lightAngle), dy: sin(lightAngle))

        var highlights: [Double] = []
        var shadows: [Double] = []

        for i in 0..<samples {
            let t = Double(i) / Double(samples)
            let n = roundedRectNormal(t: t, width: width, height: height, radius: cornerRadius)
            // Normaliser la normale
            let nLen = sqrt(n.dx * n.dx + n.dy * n.dy)
            let norm = CGVector(dx: n.dx / nLen, dy: n.dy / nLen)
            let dot = norm.dx * lightDir.dx + norm.dy * lightDir.dy

            if dot >= highlightThreshold { highlights.append(t) }
            if dot <= shadowThreshold { shadows.append(t) }
        }

        // Prendre la plus grande zone consécutive de highlights
        func longestRun(_ arr: [Double]) -> (Double, Double)? {
            guard !arr.isEmpty else { return nil }
            var best: (Double, Double) = (arr[0], arr[0])
            var current: (Double, Double) = (arr[0], arr[0])
            for i in 1..<arr.count {
                if arr[i] - arr[i-1] < 2.1/Double(samples) {
                    current.1 = arr[i]
                } else {
                    if current.1 - current.0 > best.1 - best.0 { best = current }
                    current = (arr[i], arr[i])
                }
            }
            if current.1 - current.0 > best.1 - best.0 { best = current }
            return best
        }

        let xAndY = longestRun(highlights) ?? (0.0, 0.0)
        let aAndB = longestRun(shadows) ?? (0.0, 0.0)

        var values = [
            GradientValue(intensity: 1.0, position: xAndY.0),
            GradientValue(intensity: 1.0, position: xAndY.1),
            GradientValue(intensity: 0.0, position: aAndB.0),
            GradientValue(intensity: 0.0, position: aAndB.1)
        ]
        
        values = values.sorted { $0.position < $1.position }
        
        return values
    }
    
    
    
    // MARK: Inner Objects
    
    struct GradientValue {
        var intensity: CGFloat
        var position: Double
    }
}
