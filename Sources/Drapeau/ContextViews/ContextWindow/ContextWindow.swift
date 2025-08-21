//
//  ContextWindow.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 26/06/2025.
//

import SwiftUI
import Styles


public struct ContextWindow<Content: View, BottomContent: View>: View {
    
    // MARK: Attributes
    
    @EnvironmentObject var metrics: ScreenMetrics
    
    @State private var toolbarItems: [ErasedContextToolbarItem] = []
    @State private var toolbarHeight: CGFloat = 0
    @State private var toolbarTitleConfig: ContextToolbarTitleConfiguration? = nil
    var contentStyle: Style = .inline
    
    var content: Content
    var bottomContent: BottomContent
    
    
    
    // MARK: Init
    
    public init(@ViewBuilder content: () -> Content, @ViewBuilder bottomContent: () -> BottomContent) {
        self.content = content()
        self.bottomContent = bottomContent()
    }
    
    
    
    // MARK: View
    
    public var body: some View {
        ZStack(alignment: .top) {
            mainContent
            
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
        .padding(8)
        .ignoresSafeArea()
    }
    
    
    var mainContent: some View {
        VStack(spacing: 0) {
            content
                .onPreferenceChange(ContextToolbarPreferenceKey.self) { value in
                    toolbarItems = value
                }
                .onPreferenceChange(ContextToolbarTitlePreferenceKey.self) { value in
                    toolbarTitleConfig = value
                }
            
            VStack(spacing: 16) {
                bottomContent
            }
            .padding([.horizontal, .bottom], metrics.borderRadius / 2)
            .padding(.top, 20)
        }
        .padding(.top, contentStyle == .inline ? toolbarHeight : 0)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.drapPrimaryBackground)
    }
    
    
    var toolbarView: some View {
        VStack {
            ContextToolbar(items: $toolbarItems, titleConfig: toolbarTitleConfig)
                .background {
                    GeometryReader { geo in
                        Color.clear
                            .onChange(of: geo.size) { value in
                                toolbarHeight = value.height
                            }
                    }
                }
        }
    }
    
    
    
    // MARK: Methods
    
    func windowDimensions() -> CGSize {
        let maxedWidth: CGFloat = min(metrics.width - 16, 500)
        let maxedHeight: CGFloat = min(metrics.height / 2, 500)
        return CGSize(width: maxedWidth, height: maxedHeight)
    }
    
    
    
    // MARK: Inner Objects
    
    public enum Style {
        case inline, stack
    }
}





#Preview {
    PreviewScaffold(backgroundColor: .drapDarkGray, disablePadding: true) {
        VStack {
            Spacer()
            
            ContextWindow {
                VStack {
                    Rectangle()
                        .foregroundStyle(Color.drapQuaternaryText)
                }
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
            } bottomContent: {
                Text("Appuyez sur “Scanner la balise” et collez votre appareil sur celle-ci")
                    .contextWindowDescription()
                
                DrapButton(icon: "square.split.diagonal.fill", title: "Scanner la balise") {
                    print("")
                }
            }
            .style(.stack)
            .drapButtonExpand()
            .drapButtonTint(.drapBlue)
        }
    }
    .ignoresSafeArea()
}

