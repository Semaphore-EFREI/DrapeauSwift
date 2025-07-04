//
//  DrApp.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 26/06/2025.
//

import SwiftUI
import Constants


public struct DrApp<Content: View>: View {
    
    // MARK: Attributes
    
    @StateObject var metrics = ScreenMetrics()
    @StateObject var drapManager = DrapContextWindowManager()
    public var content: Content
    
    
    
    // MARK: Init
    
    public init(content: () -> Content) {
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
                Color.clear
                    .ignoresSafeArea()
                    .onAppear {
                        metrics.update(from: geo, safeInsets: safeInsets)
                    }
                    .onChange(of: geo.size) {
                        metrics.update(from: geo, safeInsets: safeInsets)
                    }
                    .onChange(of: geo.safeAreaInsets) {
                        metrics.update(from: geo, safeInsets: safeInsets)
                    }
                
                content
                
                contextView
            }
            .environmentObject(metrics)
            .environmentObject(drapManager)
        }
    }
    
    
    var contextView: some View {
        ZStack {
            if drapManager.isPresented, drapManager.firstWindow != nil || drapManager.secondWindow != nil {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        drapManager.dismiss()
                    }
                
                VStack {
                    Spacer()
                    
                    if let contextWindow = drapManager.firstWindow {
                        contextWindow
                            .transition(.asymmetric(
                                insertion: .move(edge: drapManager.inDirection),
                                removal: .move(edge: drapManager.outDirection)
                            ))
                    } else if let contextWindow = drapManager.secondWindow {
                        contextWindow
                            .transition(.asymmetric(
                                insertion: .move(edge: drapManager.inDirection),
                                removal: .move(edge: drapManager.outDirection)
                            ))
                    }
                }
                .ignoresSafeArea()
            }
        }
    }
}





#Preview {
    DrApp {
        Text("Drapeau")
    }
}
