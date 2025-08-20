//
//  ContextToolbarTitleConfiguration.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 20/08/2025.
//

import SwiftUI


struct ContextToolbarTitleConfiguration: Equatable {
    var title: String
    var description: String?
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.title == rhs.title && lhs.description == rhs.description
    }
}


struct ContextToolbarTitlePreferenceKey: PreferenceKey {
    static var defaultValue: ContextToolbarTitleConfiguration {
        ContextToolbarTitleConfiguration(title: "")
    }
    
    static func reduce(value: inout ContextToolbarTitleConfiguration, nextValue: () -> ContextToolbarTitleConfiguration) {
        value = nextValue()
    }
}



public extension View {
    func contextToolbarTitle(_ title: String, description: String? = nil) -> some View {
        self
            .preference(key: ContextToolbarTitlePreferenceKey.self, value: ContextToolbarTitleConfiguration(title: title, description: description))
    }
}
