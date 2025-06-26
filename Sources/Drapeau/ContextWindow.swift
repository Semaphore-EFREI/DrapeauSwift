//
//  ContextWindow.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 26/06/2025.
//

import SwiftUI
import Constants


struct ContextWindow: View {
    
    // MARK: Attributes
    
    @EnvironmentObject var metrics: ScreenMetrics
    
    
    
    // MARK: View
    
    var body: some View {
        let dimensions: CGSize = windowDimensions()
        
        ZStack {
            ConstantsAssets.image(named: "iPhone sur Balise")
                .resizable()
                .scaledToFill()
                .frame(width: dimensions.width, height: dimensions.height)
                .clipped()
            
            
            menuBar
            
        }
        .frame(height: metrics.height / 2)
        .unevenRoundedCorners(topLeading: RoundedCornersStyle.extraLarge.rawValue, topTrailing: RoundedCornersStyle.extraLarge.rawValue, bottomTrailing: metrics.borderRadius - 8, bottomLeading: metrics.borderRadius - 8)
        //.drapReflectWithUnevenCorners(cornersStyle: .extraLarge, bottomLeading: metrics.borderRadius - 8, bottomTrailing: metrics.borderRadius - 8, reflectStyle: .primary)
        .padding(8)
        .ignoresSafeArea()
    }
    
    
    var menuBar: some View {
        VStack {
            ContextMenuBar {
                DrapButton(icon: "chevron.left", title: "Annuler", tint: .drapPrimaryText, kind: .small) {
                    print("")
                }
            } trailing: {
                DrapButton(icon: "qrcode.viewfinder", tint: .drapPrimaryText, kind: .small) {
                    print("")
                }
            }

            Spacer()
        }
    }
    
    
    
    // MARK: Methods
    
    func windowDimensions() -> CGSize {
        let maxedWidth: CGFloat = min(metrics.width - 16, 500)
        let maxedHeight: CGFloat = min(metrics.height / 2, 500)
        return CGSize(width: maxedWidth, height: maxedHeight)
    }
}





#Preview {
    PreviewScaffold(backgroundColor: .drapDarkGray, disablePadding: true) {
        VStack {
            Spacer()
            ContextWindow()
        }
        .ignoresSafeArea()
    }
}
