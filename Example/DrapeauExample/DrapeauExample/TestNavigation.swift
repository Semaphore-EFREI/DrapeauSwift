//
//  TestNavigation.swift
//  DrapeauExample
//
//  Created by Thomas Le Bonnec on 25/06/2025.
//

import SwiftUI
import DrapeauSwift

struct TestNavigation: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                Text("Bonjour monde")
                    .frame(maxWidth: .infinity)
            }
            .background(Color.blue)
            .navigationTitle("Bonjour")
            .toolbar {
                ToolbarItem(placement: .largeTitle) {
                    Text("Hello")
                        .drapTitle()
                        .padding(.horizontal, 8)
                }
            }
        }
    }
}





#Preview {
    TestNavigation()
}
