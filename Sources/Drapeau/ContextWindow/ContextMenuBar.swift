//
//  ContextMenuBar.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 27/06/2025.
//

import SwiftUI


public struct ContextMenuBar: View {
    
    // MARK: Attributes
    
    public var leading: (() -> DrapButton)?
    public var trailing: (() -> DrapButton)?
    
    
    
    // MARK: Init
    
    public init(leading: (() -> DrapButton)? = nil, trailing: (() -> DrapButton)? = nil) {
        self.leading = leading
        self.trailing = trailing
    }
    
    
    
    // MARK: View
    
    public var body: some View {
        HStack {
            if let leading = leading {
                leading()
            }
            
            Spacer()
            
            if let trailing = trailing {
                trailing()
            }
        }
        .padding(16)
    }
}





#Preview {
    ContextMenuBar(leading: {
        DrapButton(title: "Button", kind: .small) {
            print("")
        }
    })

}
