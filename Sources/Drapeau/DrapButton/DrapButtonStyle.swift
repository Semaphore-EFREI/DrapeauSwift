//
//  DrapButtonStyle.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 05/08/2025.
//

import SwiftUI
import Styles


@MainActor public protocol DrapButtonStyle {
    associatedtype Body: View
    
    @ViewBuilder @MainActor func makeBody(configuration: DrapButtonConfiguration) -> Self.Body
}


public extension DrapButtonStyle where Self == DefaultDrapButtonStyle {
    @MainActor static var `default`: Self {
        get {
            return Self()
        }
    }
}

public extension DrapButtonStyle where Self == ActionBarDrapButtonStyle {
    @MainActor static var actionBar: Self {
        get {
            return Self()
        }
    }
}




public extension DrapButton {
    /// Change le style d'un bouton.
    func style<S: DrapButtonStyle>(_ style: S) -> DrapButton<S> {
        return DrapButton<S>(config: self.config, style: style)
    }
}
