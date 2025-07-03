//
//  TestAnimation.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 03/07/2025.
//

import SwiftUI

struct TestAnimation: View {
    
    @State var view1: Text? = Text("Bonjour")
    @State var view2: Text? = nil
    @State var inEdge = Edge.trailing
    @State var outEdge = Edge.leading
    
    
    var body: some View {
        VStack(spacing: 16) {
            if let view1 {
                view1
                    .transition(.asymmetric(
                        insertion: .move(edge: inEdge),
                        removal: .move(edge: outEdge)
                    ))
                    .frame(maxWidth: .infinity)
                    .background(Color.drapPrimaryBackground)
                    .padding()
            } else if let view2 {
                view2
                    .transition(.asymmetric(
                        insertion: .move(edge: inEdge),
                        removal: .move(edge: outEdge)
                    ))
                    .frame(maxWidth: .infinity)
                    .background(Color.drapPrimaryBackground)
                    .padding()
            }
            
            DrapButton(title: "Changer la vue") {
                withAnimation {
                    if view1 == nil {
                        inEdge = .leading
                        outEdge = .trailing
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                            withAnimation {
                                view1 = Text("Bonjour")
                                view2 = nil
                            }
                        }
                    } else {
                        inEdge = .trailing
                        outEdge = .leading
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                            withAnimation {
                                view2 = Text("Truc")
                                view1 = nil
                            }
                        }
                    }
                }
            }
            
            DrapButton(title: "Supprimer la vue", tint: .drapRed, kind: .tertiary) {
                withAnimation {
                    inEdge = .bottom
                    outEdge = .bottom
                    if view1 == nil && view2 == nil {
                        view1 = Text("Bonjour")
                        view2 = nil
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                            withAnimation {
                                view2 = nil
                                view1 = nil
                            }
                        }
                    }
                }
            }
        }
    }
}




#Preview {
    PreviewScaffold {
        TestAnimation()
    }
}
