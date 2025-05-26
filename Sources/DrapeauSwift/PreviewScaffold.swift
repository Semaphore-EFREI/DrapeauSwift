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
    
    let content: Content
    
    
    
    // MARK: Init
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
        
        do {
            try FontLoader.registerFonts()
        } catch { }
    }
    
    
    
    // MARK: View

    public var body: some View {
        ZStack {
            Color.drapPrimaryBackground
                .ignoresSafeArea()
            
            content
                .padding(24)
        }
    }
}
