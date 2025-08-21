//
//  DrapButtonConfiguration.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 05/08/2025.
//

import SwiftUI
import Styles


public struct DrapButtonConfiguration {
    let id = UUID()
    var title: String?
    var icon: String?
    
    var disabled: Bool
    
    // iOS 26 +
    var glassEffect: Bool = true
    
    var action: () -> Void
}
