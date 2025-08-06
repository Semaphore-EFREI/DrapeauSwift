//
//  PreviewScaffold.swift
//  DrapeauSwift
//
//  Created by Thomas Le Bonnec on 26/05/2025.
//

import SwiftUI
import Constants


public struct PreviewScaffold<Content: View>: View {
    
    // MARK: Attributes
    
    @StateObject var metrics = ScreenMetrics()
    //@StateObject var drapManager = DrapContextWindowManager()
    
    var backgroundColor: Color
    var disablePadding: Bool
    let content: Content
    
    
    
    // MARK: Init
    
    public init(backgroundColor: Color = .drapSecondaryBackground, disablePadding: Bool = false, @ViewBuilder content: () -> Content) {
        self.backgroundColor = backgroundColor
        self.disablePadding = disablePadding
        self.content = content()
        
        do {
            try FontLoader.registerFonts()
        } catch { }
    }
    
    
    
    // MARK: View

    public var body: some View {
        GeometryReader { geo in
            let safeInsets = geo.safeAreaInsets
            
            ZStack {
                backgroundColor
                    .ignoresSafeArea()
                    .onAppear {
                        metrics.update(from: geo, safeInsets: safeInsets)
                    }
                    /*.onChange(of: geo.size) {
                        metrics.update(from: geo, safeInsets: safeInsets)
                    }
                    .onChange(of: geo.safeAreaInsets) {
                        metrics.update(from: geo, safeInsets: safeInsets)
                    }*/
                
                content
                    .padding(.horizontal, disablePadding ? 0 : 24)
                    .environmentObject(metrics)
                    //.environmentObject(drapManager)
            }
        }
    }
}





#Preview {
    PreviewScaffold {
        Text("Bonjour, monde !")
    }
}
