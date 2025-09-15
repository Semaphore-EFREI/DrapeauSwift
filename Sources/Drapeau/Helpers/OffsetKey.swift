//
//  OffsetKey.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 15/09/2025.
//

import SwiftUI

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
