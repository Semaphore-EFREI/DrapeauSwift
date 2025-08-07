//
//  DrapTextField.swift
//  DrapeauSwift
//
//  Created by Thomas Le Bonnec on 26/05/2025.
//

import SwiftUI
import Styles


public struct DrapTextField: View {
    
    // MARK: Attributes
    
    @Environment(\.drapTextFieldFormat) var format
    
    var label: String?
    var placeholder: String?
    @Binding var value: String
    var isPassword: Bool = false
    
    
    
    // MARK: Init
    
    public init(label: String?, placeholder: String?, value: Binding<String>, isPassword: Bool) {
        self.label = label
        self.placeholder = placeholder
        self._value = value
        self.isPassword = isPassword
    }
    
    
    
    // MARK: View
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if label != nil {
                labelView
            }
            
            textFieldView
        }
    }
    
    
    var labelView: some View {
        Text(label ?? "")
            .drapDescription()
            .foregroundStyle(Color.drapTertiaryText)
            .padding(.leading, labelPadding)
    }
    
    
    var textFieldView: some View {
        Group {
            if isPassword {
                SecureField("", text: $value, prompt: promptView)
                    .textFieldStyle(.plain)
            } else {
                TextField("", text: $value, prompt: promptView)
                    .textFieldStyle(.plain)
            }
        }
        .drapBody()
        .autocorrectionDisabled()
        #if !os(macOS)
        .textInputAutocapitalization(.never)
        #endif
        .foregroundStyle(Color.drapPrimaryText)
        .padding(.vertical, padding.height)
        .padding(.horizontal, padding.width)
        .conditionalBackground(cornersStyle: roundedCorners, backgroundColor: backgroundColor)
    }
    
    
    var promptView: Text {
        Text(placeholder ?? "")
            .drapBody()
            .foregroundColor(Color.drapQuaternaryText)
    }
    
    
    
    // MARK: Computed Properties
    
    var padding: CGSize {
        return switch format {
        case .regular:
            .init(width: 14, height: 12)
        case .capsule:
            .init(width: 15, height: 14.5)
        }
    }
    
    
    var labelPadding: CGFloat {
        return switch format {
        case .regular: 8
        case .capsule: 12
        }
    }
    
    
    var roundedCorners: RoundedCornersStyle {
        return switch format {
        case .regular:
            .regular
        case .capsule:
            .round
        }
    }
    
    
    var backgroundColor: Color {
        return switch format {
        case .regular:
            .drapSecondaryBackground
        case .capsule:
            .drapTertiaryBackground
        }
    }
}






#Preview {
    //@Previewable @State var value = ""
    
    PreviewScaffold {
        DrapTextField(label: "Étiquette", placeholder: "Bouche trou", value: .constant(""), isPassword: false)
            .drapTextFieldFormat(.capsule)
    }
}
