//
//  ContextToolbarTitle.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 20/08/2025.
//

import SwiftUI


struct ContextToolbarTitle: View {
    
    // MARK: Attributes
    
    var config: ContextToolbarTitleConfiguration
    
    var singleLine: Bool = false
    
    
    
    // MARK: View
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(config.title)
                .drapImportantBody()
                .foregroundStyle(Color.drapPrimaryText)
                .lineLimit(singleLine ? 1 : nil)
            
            if let description = config.description {
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





#Preview {
    PreviewScaffold {
        ContextToolbarTitle(config: ContextToolbarTitleConfiguration(title: "Titre de la fenêtre", description: "Description de la fenêtre"))
    }
}
