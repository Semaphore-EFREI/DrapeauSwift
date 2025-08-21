//
//  TestView.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 08/08/2025.
//

import SwiftUI


@available(macOS 26.0, iOS 26.0, *)
struct TestView: View {
    var body: some View {
        ZStack {
            Color
                .drapSecondaryBackground
                .ignoresSafeArea()
            
            VStack {
                NavigationStack {
                    Text("Bonjour")
                        .toolbar {
                            buttonView
                        }
                    
                        .navigationTitle("Truc")
                        .navigationSubtitle("Test")
                        .toolbarTitleDisplayMode(.inline)
                }
                //.drapButtonFormat(.circle)
            }
            .frame(height: 400)
            .padding()
        }
    }
    
    
    
    var buttonView: some View {
        DrapButton(icon: "circle.fill", title: nil) {
            print("")
        }
        .style(ActionBarDrapButtonStyle())
        .drapButtonFormat(.simple)
    }
}




@available(macOS 26.0, iOS 26.0, *)
#Preview {
    TestView()
}
