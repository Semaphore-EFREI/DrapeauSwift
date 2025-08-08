//
//  MultilineDrapTextFieldStyle.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 07/08/2025.
//

import SwiftUI


public struct MultilineDrapTextFieldStyle: DrapTextFieldStyle {
    
    // MARK: - Methods
    
    public func makeBody(configuration: DrapTextFieldConfiguration, value: Binding<String>) -> some View {
        MultilineDrapTextField(configuration: configuration, value: value)
    }
    
    
    
    // MARK: - View
    
    fileprivate struct MultilineDrapTextField: View {
        
        // MARK: Attributes
        
        var configuration: DrapTextFieldConfiguration
        @Binding var value: String
        
        
        
        // MARK: View
        
        var body: some View {
            Group {
                if #available(iOS 16.0, macOS 13.0, *) {
                    TextField("", text: $value, prompt: placeholderView, axis: .vertical)
                        .lineLimit(5)
                } else {
                    TextField("", text: $value, prompt: placeholderView)
                        .lineLimit(5)
                }
            }
            .drapBody()
            .apply() {
                if #available(iOS 17.0, macOS 14.0, *) {
                    $0
                        .textEditorStyle(.plain)
                } else { $0 }
            }
            .foregroundStyle(Color.drapPrimaryText)
            .padding(.horizontal, 15)
            .padding(.vertical, 15)
            .conditionalBackground(cornersStyle: .medium, backgroundColor: backgroundColor)
        }
        
        
        var placeholderView: Text {
            Text(configuration.placeholder ?? "")
                .drapBody()
            .foregroundColor(Color.drapQuaternaryText)
        }
        
        
        
        // MARK: Computed Properties
        
        var backgroundColor: Color? {
            if #available(iOS 26.0, macOS 26.0, *) {
                return nil
            }
            return .drapPrimaryBackground
        }
    }
}
