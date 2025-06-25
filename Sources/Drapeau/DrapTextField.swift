//
//  DrapTextField.swift
//  DrapeauSwift
//
//  Created by Thomas Le Bonnec on 26/05/2025.
//

import SwiftUI


public struct DrapTextField: View {
    
    // MARK: Attributes
    
    public var label: String
    @Binding public var value: String
    public var isPassword: Bool = false
    
    
    
    // MARK: View
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Étiquette")
                .drapDescription()
                .foregroundStyle(Color.drapTertiaryText)
                .padding(.leading, 2)
            
            textFieldView
                .drapBody()
                .autocorrectionDisabled()
                #if !os(macOS)
                .textInputAutocapitalization(.never)
                #endif
                .foregroundStyle(Color.drapPrimaryText)
                .padding(.vertical, 12)
                .padding(.horizontal, 14)
                .background(Color.drapPrimaryBackground)
                .roundedCorners(style: .regular)
        }
    }
    
    
    var textFieldView: some View {
        Group {
            if isPassword {
                SecureField("", text: $value, prompt: promptView)
            } else {
                TextField("", text: $value, prompt: promptView)
            }
        }
    }
    
    
    var promptView: Text {
        Text("TextField")
            .drapBody()
            .foregroundStyle(Color.drapQuaternaryText)
    }
}






#Preview {
    @Previewable @State var value = ""
    
    PreviewScaffold {
        DrapTextField(label: "Étiquette", value: $value, isPassword: true)
    }
}
