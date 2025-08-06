//
//  DrapButton.swift
//  DrapeauSwift
//
//  Created by Thomas Le Bonnec on 26/05/2025.
//

import SwiftUI
import Constants


public struct DrapButton<Style: DrapButtonStyle>: View {
    
    // MARK: Attributes
    
    var disabled: Bool
    var action: () -> Void
    
    var config: DrapButtonConfiguration
    var style: Style
    
    
    
    // MARK: Init
    
    init(icon: String? = nil, title: String? = nil, disabled: Bool = false, style: Style, action: @escaping () -> Void) {
        self.disabled = disabled
        self.action = action
        
        self.config = DrapButtonConfiguration(title: title, icon: icon)
        self.style = style
    }
    
    
    init(disabled: Bool = false, config: DrapButtonConfiguration, style: Style, action: @escaping () -> Void) {
        self.disabled = disabled
        self.action = action
        self.config = config
        self.style = style
    }
    
    
    
    // MARK: Views
    
    public var body: some View {
        Button {
            action()
        } label: {
            style.makeBody(configuration: config)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(disabled)
    }
}



public extension DrapButton where Style == DefaultDrapButtonStyle {
    init(icon: String? = nil, title: String? = nil, disabled: Bool = false, action: @escaping () -> Void) {
        self.init(icon: icon, title: title, disabled: disabled, style: DefaultDrapButtonStyle(), action: action)
    }
}





#Preview {
    PreviewScaffold(backgroundColor: .drapQuaternaryBackground) {
        VStack(spacing: 24) {
            DrapButton(icon: "signature", title: "Hello") {}
            DrapButton(icon: "signature", title: "Hello") {}
                .drapButtonRole(.tertiary)
                .drapButtonTint(.drapBlack)
            DrapButton(icon: "signature", title: "Hello") {}
            DrapButton(icon: "signature", title: "Hello") {}
            DrapButton(icon: "signature", title: "Hello") {}
            DrapButton(icon: "signature", title: "Hello") {}
            DrapButton(icon: "signature", title: "Hello") {}
            DrapButton(icon: "signature", title: "Hello") {}
        }
    }
}
