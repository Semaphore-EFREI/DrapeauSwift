//
//  ContextWindow.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 26/06/2025.
//

import SwiftUI
import Styles


public struct ContextWindow<Content: View>: View {
    
    // MARK: Attributes
    
    @EnvironmentObject var metrics: ScreenMetrics
    
    @State var items: [ErasedContextToolbarItem] = []
    @State var toolbarTitleConfig: ContextToolbarTitleConfiguration? = nil
    var content: Content
    
    
    
    // MARK: Init
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    
    
    // MARK: View
    
    public var body: some View {
        ZStack {
            content
                .onPreferenceChange(ContextToolbarPreferenceKey.self) { value in
                    items = ordered(value)
                }
                .onPreferenceChange(ContextToolbarTitlePreferenceKey.self) { value in
                    toolbarTitleConfig = value
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.drapPrimaryBackground)
            
            toolbarView
        }
        .frame(height: metrics.height / 2)
        .apply {
            if #available(iOS 16.0, macOS 13.0, *) {
                $0.unevenRoundedCorners(style: .extraLarge, bottomTrailing: metrics.borderRadius - 8, bottomLeading: metrics.borderRadius - 8, borderStyle: .primary)
            } else {
                $0.roundedCorners(style: .large)
            }
        }
    }
    
    
    var toolbarView: some View {
        VStack {
            ContextToolbar(items: $items, titleConfig: toolbarTitleConfig)
            Spacer()
        }
    }
    
    
    
    // MARK: Methods
    
    func windowDimensions() -> CGSize {
        let maxedWidth: CGFloat = min(metrics.width - 16, 500)
        let maxedHeight: CGFloat = min(metrics.height / 2, 500)
        return CGSize(width: maxedWidth, height: maxedHeight)
    }
    
    func ordered(_ items: [ErasedContextToolbarItem]) -> [ErasedContextToolbarItem] {
        func rank(_ p: ContextToolbarPlacement) -> Int {
            switch p { case .leading: return 0; case .trailing: return 2 }
        }
        return items.sorted {
            let a = (rank($0.placement), String(describing: $0.id))
            let b = (rank($1.placement), String(describing: $1.id))
            return a < b
        }
    }
}





#Preview {
    PreviewScaffold(backgroundColor: .drapDarkGray, disablePadding: true) {
        VStack {
            Spacer()
            
            ContextWindow {
                DrapButton(icon: "square.split.diagonal.fill", title: "Scanner la balise") {
                    print("")
                }
                .drapButtonExpand()
                .drapButtonTint(.drapBlue)
                .padding()
                .contextToolbarTitle("Titre de la fenêtre", description: "Ceci est une description")
                .contextToolbar {
                    ContextToolbarButton(placement: .leading) {
                        DrapButton(icon: "chevron.left") {
                            print("")
                        }
                        .style(.actionBar)
                    }
                    
                    ContextToolbarButton(placement: .trailing) {
                        DrapButton(icon: "qrcode.viewfinder", title: "QR Code") {
                            print("")
                        }
                        .style(.actionBar)
                    }
                }
            }
        }
        .padding(8)
        .ignoresSafeArea()
    }
}

