//
//  InlineDrapTextFieldStyle.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 07/08/2025.
//

import SwiftUI


public struct InlineDrapTextFieldStyle: DrapTextFieldStyle {
    
    // MARK: - Methods
    
    public func makeBody(configuration: DrapTextFieldConfiguration, value: Binding<String>) -> some View {
        InlineDrapTextField(configuration: configuration, value: value)
    }
    
    
    
    // MARK: - View
    
    fileprivate struct InlineDrapTextField: View {
        
        // MARK: Attributes
        
        @Environment(\.drapTextFieldRole) var role
        
        var configuration: DrapTextFieldConfiguration
        @Binding var value: String
        
        
        
        // MARK: View
        
        var body: some View {
            VStack(alignment: .leading, spacing: 6) {
                if configuration.label != nil {
                    labelView
                }
                
                textFieldView
            }
        }
        
        
        var labelView: some View {
            Text(configuration.label ?? "")
                .drapDescription()
                .foregroundStyle(Color.drapTertiaryText)
                .padding(.leading, 8)
        }
        
        
        var textFieldView: some View {
            Group {
                if configuration.secured {
                    SecureField("", text: $value, prompt: placeholderView)
                        .textFieldStyle(.plain)
                } else {
                    TextField("", text: $value, prompt: placeholderView)
                        .textFieldStyle(.plain)
                }
            }
            .drapBody()
            .autocorrectionDisabled()
            #if !os(macOS)
            .textInputAutocapitalization(.never)
            #endif
            .foregroundStyle(Color.drapPrimaryText)
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .conditionalBackground(cornersStyle: .round, liquidBackgroundColor: liquidBackgroundColor, backgroundColor: backgroundColor)
        }
        
        
        var placeholderView: Text {
            Text(configuration.placeholder ?? "")
                .drapBody()
                .foregroundColor(Color.drapQuaternaryText)
        }
        
        
        
        // MARK: Computed Properties
        
        var backgroundColor: Color {
            return switch role {
            case .primary:
                .drapPrimaryBackground
            case .secondary:
                .drapSecondaryBackground
            }
        }
        
        var liquidBackgroundColor: Color {
            .drapTertiaryBackground
        }
    }
}
