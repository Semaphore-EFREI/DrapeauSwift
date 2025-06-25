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
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            
            content
                .padding(.horizontal, disablePadding ? 0 : 16)
        }
    }
}





#Preview {
    PreviewScaffold {
        Text("Bonjour, monde !")
    }
}
