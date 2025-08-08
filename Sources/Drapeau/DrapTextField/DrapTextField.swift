//
//  DrapTextField.swift
//  DrapeauSwift
//
//  Created by Thomas Le Bonnec on 26/05/2025.
//

import SwiftUI
import Styles


public struct DrapTextField<Style: DrapTextFieldStyle>: View {
    
    // MARK: Attributes
    
    @Binding var value: String
    
    var configuration: DrapTextFieldConfiguration
    var style: Style
    
    
    
    // MARK: Init
    
    init(label: String? = nil, placeholder: String? = nil, value: Binding<String>, secured: Bool = false, style: Style) {
        self._value = value
        self.style = style
        self.configuration = DrapTextFieldConfiguration(label: label, placeholder: placeholder, secured: secured)
    }
    
    init(value: Binding<String>, configuration: DrapTextFieldConfiguration, style: Style) {
        self._value = value
        self.style = style
        self.configuration = configuration
    }
    
    
    
    // MARK: View
    
    public var body: some View {
        style.makeBody(configuration: configuration, value: $value)
    }
}



public extension DrapTextField where Style == InlineDrapTextFieldStyle {
    init(label: String? = nil, placeholder: String? = nil, value: Binding<String>, secured: Bool = false) {
        self.init(label: label, placeholder: placeholder, value: value, secured: secured, style: InlineDrapTextFieldStyle())
    }
}






#Preview {
    //@Previewable @State var value = ""
    
    PreviewScaffold {
        ZStack {
            // Rectangle pour voir l'effet du fond du champ de texte
            Rectangle()
                .frame(width: 200, height: 200)
                .padding(.top, 200)
                .foregroundStyle(Color.drapBlue)
            
            DrapTextField(placeholder: "Test", value: .constant("Bonjour Bonjour Bonjour Bonjour Bonjour Bonjour Bonjour Bonjour Bonjour Bonjour Bonjour Bonjour Bonjour Bonjour Bonjour Bonjour Bonjour Bonjour Bonjour Bonjour Bonjour Bonjour Bonjour Bonjour Bonjour Bonjour Bonjour"), secured: false)
                .style(.multiline)
        }
    }
}
