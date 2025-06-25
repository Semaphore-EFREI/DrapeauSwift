//
//  InfoBox.swift
//  DrapeauSwift
//
//  Created by Thomas Le Bonnec on 26/05/2025.
//

import SwiftUI


public struct InfoBox: View {
    
    // MARK: Attributes
    
    public var title: String
    public var content: String
    public var style: InfoBoxStyle = .primaryLeading
    
    
    
    // MARK: View
    
    public var body: some View {
        VStack(alignment: style.parameters.horizontalAlignment, spacing: 4) {
            Text(title)
                .drapImportantBody()
                .frame(maxWidth: .infinity, alignment: style.parameters.alignment)
            
            Text(content)
                .drapBody()
        }
        .foregroundStyle(style.parameters.foregroundColor)
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(Color.drapSecondaryBackground)
        .roundedCorners(style: .regular)
    }
    
    
    
    // MARK: Internal Objects
    
    public enum InfoBoxStyle {
        case primaryLeading
        case secondaryLeading
        case primaryCenter
        case secondaryCenter
        
        
        var parameters: InfoBoxParameters {
            return switch self {
            case .primaryLeading:
                InfoBoxParameters(
                    foregroundColor: .drapPrimaryText,
                    alignment: .leading
                )
            case .secondaryLeading:
                InfoBoxParameters(
                    foregroundColor: .drapTertiaryText,
                    alignment: .leading
                )
            case .primaryCenter:
                InfoBoxParameters(
                    foregroundColor: .drapPrimaryText,
                    alignment: .center
                )
            case .secondaryCenter:
                InfoBoxParameters(
                    foregroundColor: .drapTertiaryText,
                    alignment: .center
                )
            }
        }
    }
    
    
    struct InfoBoxParameters {
        var foregroundColor: Color
        var alignment: Alignment
        
        var horizontalAlignment: HorizontalAlignment {
            if alignment == .leading { return .leading }
            else { return .center }
        }
    }
}





#Preview {
    PreviewScaffold(backgroundColor: .drapPrimaryBackground) {
        InfoBox(title: "Cartouche", content: "Contenu")
    }
}
