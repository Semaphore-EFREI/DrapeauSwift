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
    
    var backgroundColor: Color
    let content: Content
    
    
    
    // MARK: Init
    
    init(backgroundColor: Color = .drapSecondaryBackground, @ViewBuilder content: () -> Content) {
        self.backgroundColor = backgroundColor
        self.content = content()
        
        do {
            try FontLoader.registerFonts()
        } catch { }
    }
    
    
    
    // MARK: View

    public var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            
            content
                .padding(24)
        }
    }
}





#Preview {
    PreviewScaffold {
        Text("Bonjour, monde !")
    }
}
