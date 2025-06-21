//
//  Test.swift
//  DrapeauExample
//
//  Created by Thomas Le Bonnec on 21/06/2025.
//

import SwiftUI
import DrapeauSwift

struct Test: View {
    var body: some View {
        VStack {
            Text("Bonjour, monde !")
        }
        .padding()
        .background(Color.drapRed)
        .cornerRadius(12)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(.black.opacity(0.1), lineWidth: 1)
        }
        /*.overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(.white, lineWidth: 1)
        }*/
    }
}

#Preview {
    Test()
}
