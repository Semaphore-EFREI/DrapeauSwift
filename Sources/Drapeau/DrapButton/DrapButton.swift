//
//  DrapButton.swift
//  DrapeauSwift
//
//  Created by Thomas Le Bonnec on 26/05/2025.
//

import SwiftUI
import Styles


public struct DrapButton<Style: DrapButtonStyle>: View {
    
    // MARK: Attributes
    
    var config: DrapButtonConfiguration
    var style: Style
    
    
    
    // MARK: Init
    
    init(icon: String? = nil, title: String? = nil, disabled: Bool = false, style: Style, action: @escaping () -> Void) {
        self.config = DrapButtonConfiguration(title: title, icon: icon, disabled: disabled, action: action)
        self.style = style
    }
    
    
    init(config: DrapButtonConfiguration, style: Style) {
        self.config = config
        self.style = style
    }
    
    
    
    // MARK: Views
    
    public var body: some View {
        Button {
            config.action()
        } label: {
            style.makeBody(configuration: config)
        }
        .buttonStyle(.plain)
        .disabled(config.disabled)
    }
}



public extension DrapButton where Style == DefaultDrapButtonStyle {
    init(icon: String? = nil, title: String? = nil, disabled: Bool = false, action: @escaping () -> Void) {
        self.init(icon: icon, title: title, disabled: disabled, style: DefaultDrapButtonStyle(), action: action)
    }
}





#Preview {
    PreviewScaffold(backgroundColor: .drapQuaternaryBackground) {
        VStack(spacing: 32) {
            if #available(iOS 26.0, macOS 26.0, *) {
                
                // MARK: iOS 26
                
                VStack(spacing: 24) {
                    HStack(alignment: .top, spacing: 24) {
                        VStack(spacing: 24) {
                            DrapButton(icon: "signature", title: "Hello") {}
                            DrapButton(icon: "signature", title: "Hello") {}
                                .drapButtonRole(.secondary)
                            DrapButton(icon: "signature", title: "Hello") {}
                                .drapButtonRole(.tertiary)
                        }
                        
                        
                        VStack(spacing: 24) {
                            DrapButton(icon: "signature") {}
                                .drapButtonRole(.primary)
                            DrapButton(icon: "signature") {}
                                .drapButtonRole(.tertiary)
                        }
                        .drapButtonFormat(.capsule)
                        
                        DrapButton(icon: "signature", title: "Hello") {}
                            .drapButtonRole(.tertiary)
                            .drapButtonFormat(.simple)
                    }
                }
                
                VStack(spacing: 24) {
                    HStack(alignment: .top, spacing: 24) {
                        VStack(spacing: 24) {
                            DrapButton(icon: "signature", title: "Hello") {}
                            DrapButton(icon: "signature", title: "Hello") {}
                                .drapButtonRole(.secondary)
                            DrapButton(icon: "signature", title: "Hello") {}
                                .drapButtonRole(.tertiary)
                        }
                        
                        VStack(spacing: 24) {
                            DrapButton(icon: "signature") {}
                                .drapButtonRole(.primary)
                            DrapButton(icon: "signature") {}
                                .drapButtonRole(.tertiary)
                        }
                        .drapButtonFormat(.capsule)
                        
                        DrapButton(icon: "signature", title: "Hello") {}
                            .drapButtonRole(.tertiary)
                            .drapButtonFormat(.simple)
                    }
                }
                .padding()
                .glassEffect(in: .rect(cornerRadius: 38))
                
                
            } else {
                
                // MARK: iOS 18
                
                VStack(spacing: 24) {
                    HStack(alignment: .top, spacing: 24) {
                        VStack(spacing: 24) {
                            DrapButton(icon: "signature", title: "Hello") {}
                            DrapButton(icon: "signature", title: "Hello") {}
                                .drapButtonRole(.secondary)
                            DrapButton(icon: "signature", title: "Hello") {}
                                .drapButtonRole(.tertiary)
                        }
                        
                        VStack(spacing: 24) {
                            DrapButton(icon: "signature", title: "Hello") {}
                                .drapButtonFormat(.capsule)
                            DrapButton(icon: "signature", title: "Hello") {}
                                .drapButtonFormat(.capsule)
                                .drapButtonRole(.secondary)
                            DrapButton(icon: "signature", title: "Hello") {}
                                .drapButtonFormat(.capsule)
                                .drapButtonRole(.tertiary)
                        }
                    }
                    
                    /*
                    HStack(alignment: .top, spacing: 24) {
                        VStack(spacing: 24) {
                            DrapButton(icon: "signature", title: "Hello") {}
                                .drapButtonRole(.primary)
                                .drapButtonFormat(.circle)
                            DrapButton(icon: "signature", title: "Hello") {}
                                .drapButtonRole(.tertiary)
                                .drapButtonFormat(.circle)
                        }
                        
                        DrapButton(icon: "signature", title: "Hello") {}
                            .drapButtonRole(.tertiary)
                            .drapButtonFormat(.simple)
                    }*/
                    
                    DrapButton(icon: "signature", title: "Hello") {}
                        .style(.actionBar)
                        .drapButtonFormat(.capsule)
                    /*
                    DrapButton(icon: "signature", title: "Hello") {}
                        .style(.actionBar)
                        .drapButtonFormat(.circle)*/
                    DrapButton(icon: "signature", title: "Hello") {}
                        .style(.actionBar)
                        .drapButtonFormat(.simple)
                    
                    
                }
            }
        }
    }
}
