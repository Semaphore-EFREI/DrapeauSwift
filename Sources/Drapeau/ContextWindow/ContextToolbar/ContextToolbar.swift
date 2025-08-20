//
//  ContextToolbar.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 27/06/2025.
//

import SwiftUI


struct ContextToolbar: View {
    
    // MARK: Attributes
    
    @Binding var items: [ErasedContextToolbarItem]
    var titleConfig: ContextToolbarTitleConfiguration?
    
    
    
    // MARK: Init
    
    init(items: Binding<[ErasedContextToolbarItem]>, titleConfig: ContextToolbarTitleConfiguration? = nil) {
        self._items = items
        self.titleConfig = titleConfig
    }
    
    
    
    // MARK: View
    
    var body: some View {
        Group {
            if #available(iOS 26.0, macOS 26.0, *) {
                ViewThatFits(in: .horizontal) {
                    inlineView
                    multilineView
                }
                .drapButtonFormat(.capsule)
                .drapButtonTint(.drapPrimaryText)
            } else {
                multilineView
            }
        }
    }
    
    
    var inlineView: some View {
        HStack(spacing: 12) {
            HStack(spacing: 6) {
                leadingButtonsView
                if let titleConfig {
                    ContextToolbarTitle(config: titleConfig, singleLine: true)
                }
            }
            trailingButtonsView
        }
        .padding(16)
    }
    
    var multilineView: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                leadingButtonsView
                Spacer()
                trailingButtonsView
            }
            if let titleConfig {
                ContextToolbarTitle(config: titleConfig, singleLine: false)
            }
        }
        .padding(16)
    }
    
    
    
    var leadingButtonsView: some View {
        HStack(spacing: 12) {
            ForEach(items.filter { $0.placement == .leading }, id: \.id) { it in it.makeBody() }
        }
    }
    
    
    var trailingButtonsView: some View {
        HStack(spacing: 12) {
            ForEach(items.filter { $0.placement == .trailing }, id: \.id) { it in it.makeBody() }
        }
    }
}




//@available(iOS 26.0, macOS 26.0, *)
#Preview {
    PreviewScaffold(disablePadding: true) {
        //VStack {
        ContextToolbar(items: .constant([
            ErasedContextToolbarItem(id: UUID(), placement: .leading, makeBody: {
                AnyView(
                    DrapButton(icon: "plus", title: "Test", disabled: false) {
                        print("")
                    }
                )
            })
        ]))
        //}
        //.glassEffect(in: .rect(cornerRadius: 38))
        //.padding()
    }
}


