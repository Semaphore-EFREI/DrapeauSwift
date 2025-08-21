//
//  ContextPopup.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 21/08/2025.
//

import SwiftUI
import Styles


public struct ContextPopup<Content: View>: View {
    
    // MARK: Attributes
    
    @State private var toolbarItems: [ErasedContextToolbarItem] = []
    @State private var toolbarTitleConfig: ContextToolbarTitleConfiguration? = nil
    
    var content: Content
    
    
    
    // MARK: Init
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    
    
    // MARK: View
    
    public var body: some View {
        VStack(spacing: 0) {
            ContextToolbar(items: $toolbarItems, titleConfig: toolbarTitleConfig)
            
            content
                .onPreferenceChange(ContextToolbarPreferenceKey.self) { value in
                    toolbarItems = value
                }
                .onPreferenceChange(ContextToolbarTitlePreferenceKey.self) { value in
                    toolbarTitleConfig = value
                }
                .padding(14)
                .padding(.top, 6)
        }
        .frame(maxWidth: .infinity)
        .conditionalBackground(cornersStyle: .extraLarge, interactive: false)
    }
}





#Preview {
    PreviewScaffold(backgroundColor: .drapDarkGray) {
        ContextPopup {
            VStack {
                DrapButton(icon: "arrow.right", title: "Suivant") {
                    print("")
                }
                .drapButtonRole(.tertiary)
                .drapButtonExpand()
            }
            .drapBody()
            .contextToolbarTitle("Signaler un retard")
            .contextToolbar {
                ContextToolbarButton(placement: .leading) {
                    DrapButton(icon: "xmark") {
                        print("")
                    }
                    .style(.actionBar)
                }
            }
        }
    }
}
