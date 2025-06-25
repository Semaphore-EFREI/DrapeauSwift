//
//  ContentView.swift
//  DrapeauExample
//
//  Created by Thomas Le Bonnec on 21/06/2025.
//

import SwiftUI
import DrapeauSwift


struct ContentView: View {
    
    @State var selection: DrapTab = .aujourdhui
    
    
    var body: some View {
        TabView(selection: $selection) {
            Tab("Passé", systemImage: "arrow.left", value: .passé) {
                Text("Passé")
            }
            
            
            Tab("Aujourd'hui", systemImage: "calendar", value: .aujourdhui) {
                TestNavigation()
            }
            
            Tab("À venir", systemImage: "arrow.right", value: .àVenir) {
                Text("À venir")
            }
        }
        .tint(Color.drapBlue)
    }
}




enum DrapTab {
    case passé
    case aujourdhui
    case àVenir
}




#Preview {
    ContentView()
}
