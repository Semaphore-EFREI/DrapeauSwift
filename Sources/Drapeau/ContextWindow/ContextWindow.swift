//
//  ContextWindow.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 26/06/2025.
//

import SwiftUI
import Constants


public struct ContextWindow<Content: View>: View {
    
    // MARK: Attributes
    
    @EnvironmentObject var metrics: ScreenMetrics
    
    public var style: Style
    public var menuBar: ContextMenuBar
    
    public var content: Content?
    
    public var image: String?
    public var description: String?
    public var actionButton: DrapButton?
    
    
    
    // MARK: Init
    
    public init(image: String, description: String, menuBar: () -> ContextMenuBar, actionButton: () -> DrapButton) {
        self.style = .structured
        self.menuBar = menuBar()
        self.image = image
        self.description = description
        self.actionButton = actionButton()
    }
    
    public init(menuBar: () -> ContextMenuBar, @ViewBuilder content: () -> Content) {
        self.style = .custom
        self.menuBar = menuBar()
        self.content = content()
    }
    
    
    
    // MARK: View
    
    public var body: some View {
        ZStack {
            if style == .custom {
                customView
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.drapPrimaryBackground)
            } else {
                structuredView
            }
            
            VStack {
                menuBar
                Spacer()
            }
            
        }
        .frame(height: metrics.height / 2)
        .unevenRoundedCorners(topLeading: RoundedCornersStyle.extraLarge.rawValue, topTrailing: RoundedCornersStyle.extraLarge.rawValue, bottomTrailing: metrics.borderRadius - 8, bottomLeading: metrics.borderRadius - 8)
        .padding(8)
        .ignoresSafeArea()
    }
    
    
    var customView: some View {
        Group {
            if let content {
                content
            } else {
                Text("Erreur d'affichage")
            }
        }
    }
    
    
    var structuredView: some View {
        let dimensions: CGSize = windowDimensions()
        
        return ZStack {
            if let image, let description, let actionButton {
                Image(image, bundle: ProjectBundle.module)
                    .resizable()
                    .scaledToFill()
                    .frame(width: dimensions.width, height: dimensions.height)
                    .clipped()
                
                VStack {
                    Spacer()
                    
                    VStack(spacing: 16) {
                        Text(description)
                            .drapDescription()
                            .multilineTextAlignment(.center)
                        actionButton
                    }
                    .padding([.horizontal, .bottom], metrics.borderRadius / 2)
                    .padding(.top, 16)
                    .background(Color.drapPrimaryBackground)
                }
            } else {
                Text("Erreur d'affichage")
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
        case custom, structured
    }
}



#Preview {
    PreviewScaffold(backgroundColor: .drapDarkGray, disablePadding: true) {
        VStack {
            Spacer()
            
            /*
            ContextWindow<Text>(image: "iPhone sur Balise", description: "Appuyez sur “Scanner la balise” et collez votre appareil sur celle-ci") {
                ContextMenuBar {
                    DrapButton(icon: "chevron.left", title: "Annuler", tint: .drapPrimaryText, kind: .small) {
                        print("")
                    }
                } trailing: {
                    DrapButton(icon: "qrcode.viewfinder", tint: .drapPrimaryText, kind: .small) {
                        print("")
                    }
                }
            } actionButton: {
                DrapButton(icon: "square.split.diagonal.fill", title: "Scanner la balise", kind: .primaryRounded) {
                    print("")
                }
            }
            */
            ContextWindow(menuBar: {
            ContextMenuBar()
            }, content: {
                Text("test")
            })

        }
        .ignoresSafeArea()
    }
}
