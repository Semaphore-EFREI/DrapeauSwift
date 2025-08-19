//
//  ContextToolbar.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 27/06/2025.
//

import SwiftUI


struct ContextToolbar: View {
    
    // MARK: Attributes
    
    var title: String?
    var description: String?
    
    var configuration: ContextMenuBarConfiguration
    
    
    
    // MARK: Init
    
    init(title: String?, description: String?, leadingButtonsConfigs: [DrapButtonConfiguration], trailingButtonsConfigs: [DrapButtonConfiguration]) {
        self.title = title
        self.description = description
        self.leadingButtonsConfigs = leadingButtonsConfigs
        self.trailingButtonsConfigs = trailingButtonsConfigs
    }
    
    
    
    // MARK: View
    
    var body: some View {
        Group {
            if #available(iOS 26.0, macOS 26.0, *) {
                ViewThatFits(in: .horizontal) {
                    inlineMenuBar
                    multilineMenuBar
                }
            } else {
                multilineMenuBar
            }
        }
    }
    
    
    var inlineMenuBar: some View {
        HStack(spacing: 12) {
            HStack(spacing: 6) {
                leadingButtonsView
                titleView(singleLine: true)
            }
            trailingButtonsView
        }
        .padding(16)
    }
    
    var multilineMenuBar: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                leadingButtonsView
                Spacer()
                trailingButtonsView
            }
            titleView(singleLine: false)
        }
        .padding(16)
    }
    
    
    
    var leadingButtonsView: some View {
        HStack(spacing: 12) {
            ForEach(leadingButtonsConfigs, id: \.id) { config in
                DrapButton(config: config, style: .actionBar)
                    .drapButtonRole(.tertiary)
                    .drapButtonFormat(.capsule)
            }
        }
    }
    
    
    var trailingButtonsView: some View {
        HStack(spacing: 12) {
            ForEach(trailingButtonsConfigs, id: \.id) { config in
                DrapButton(config: config, style: .actionBar)
                    .drapButtonRole(.tertiary)
                    .drapButtonFormat(.capsule)
            }
        }
    }
    
    
    func titleView(singleLine: Bool) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title ?? "")
                .drapImportantBody()
                .foregroundStyle(Color.drapPrimaryText)
                .lineLimit(singleLine ? 1 : nil)

            if let description {
                Text(description)
                    .drapBody()
                    .foregroundStyle(Color.drapSecondaryText)
                    .lineLimit(singleLine ? 1 : nil)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 8)
    }
}




//@available(iOS 26.0, macOS 26.0, *)
#Preview {
    PreviewScaffold(disablePadding: true) {
        //VStack {
        ContextToolbar(
                title: "Signaler un retard",
                description: "Retard de 15 min",
                leadingButtonsConfigs: [
                    .init(title: "Annuler", icon: "chevron.left", disabled: false, glassEffect: true) {
                        print("")
                    }
                ],
                trailingButtonsConfigs: [
                    .init(title: nil, icon: "person.fill", disabled: false, glassEffect: true) {
                        print("")
                    }
                ]
            )
            .drapButtonFormat(.capsule)
        //}
        //.glassEffect(in: .rect(cornerRadius: 38))
        //.padding()
    }
}


