//
//  View+Condition.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 26/06/2025.
//

import SwiftUI


extension View {
    /// Permet d'appliquer ou non un modificateur.
    ///
    ///     struct MyView: View {
    ///         @State var isRed = false
    ///
    ///         var body: some View {
    ///             Text("Hello, World!")
    ///                 .if(isRed) {
    ///                     // Style appliqué uniquement si isRed est vrai
    ///                     $0.foregroundStyle(Color.red)
    ///                 }
    ///         }
    ///     }
    ///
    @ViewBuilder
    public func `if`<Content: View>(_ condition: Bool, @ViewBuilder _ transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    
    
    /// Permet d'appliquer de la logique autour d'un modificateur
    ///
    ///     struct MyView: View {
    ///         @State var isRed = false
    ///
    ///         var body: some View {
    ///             Text("Hello, World!")
    ///                 .apply() {
    ///                     if #available(iOS 26.0, *) {
    ///                         $0.glassEffect()    // N'est appliqué que si l'appareil est sur iOS 26 ou plus
    ///                     } else {
    ///                         $0  // Ne pas oublier d'ajouter un else avec $0, sans quoi le composant sur lequel est appliqué .apply() ne sera pas visible si la condition précédente n'est pas vraie.
    ///                     }
    ///                 }
    ///         }
    ///     }
    ///
    public func apply<V: View>(@ViewBuilder _ block: (Self) -> V) -> V {
        block(self)
    }
}

