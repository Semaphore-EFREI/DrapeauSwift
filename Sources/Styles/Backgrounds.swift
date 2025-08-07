//
//  Backgrounds.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 06/08/2025.
//

import SwiftUI


public extension View {
    /// Applique un effet de verre avec un fond de couleur optionnel sur l'élément uniquement si l'appareil tourne sous iOS 26 + / macOS 26 +
    func conditionalBackground(cornersStyle: RoundedCornersStyle, backgroundColor: Color? = nil, showGlassEffect: Bool = true) -> some View {
        self
            .apply {
                if #available(iOS 26.0, macOS 26.0, *) {
                    $0
                        .if(showGlassEffect) {
                            $0.glassEffect(.regular.tint(backgroundColor).interactive(), in: .rect(cornerRadius: cornersStyle.rawValue, style: .continuous))  // TODO: Vérifier que le rect ne pose plus de problème avec le .interactive() dans les versions à venir (version actuelle : macOS 26 beta 5 / XCode beta 5)
                        }
                } else {
                    $0
                        .background(backgroundColor)
                        .roundedCorners(style: cornersStyle)
                }
            }
    }
}
