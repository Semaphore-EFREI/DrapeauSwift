//
//  DrapContextWindowManager.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 03/07/2025.
//

import SwiftUI


/*
public class DrapContextWindowManager: ObservableObject {
    
    // MARK: Attributes
    
    @Published public private(set) var isPresented: Bool = false
    @Published public private(set) var inDirection: Edge = .leading
    @Published public private(set) var outDirection: Edge = .trailing
    @Published public private(set) var firstWindow: AnyView? = nil
    @Published public private(set) var secondWindow: AnyView? = nil
    
    
    
    // MARK: Methods

    @MainActor
    public func present<Content: View>(_ content: ContextWindow<Content>, direction: AnimationDirection = .forward) {
        withAnimation {
            isPresented = true
            
            // Si un menu est déjà présent à l'écran
            if isPresented && firstWindow != nil || secondWindow != nil {
                (inDirection, outDirection) = toEdge(direction)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                    withAnimation {
                        // Les deux vue alterne (l'une devient entrante et l'autre sortante)
                        self.firstWindow = self.firstWindow == nil ? AnyView(content) : nil
                        self.secondWindow = self.firstWindow == nil ? AnyView(content) : nil        // Également basé sur firstWindow
                    }
                }
            // Si aucun menu n'est présent à l'écran
            } else {
                withAnimation {
                    inDirection = .bottom
                    firstWindow = AnyView(content)
                    secondWindow = nil
                }
            }
        }
    }

    
    @MainActor
    public func dismiss() {
        withAnimation {
            isPresented = false
            outDirection = .bottom
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                withAnimation {
                    self.firstWindow = nil
                    self.secondWindow = nil
                }
            }
        }
    }
    
    
    func toEdge(_ direction: AnimationDirection) -> (inEdge: Edge, outEdge: Edge) {
        return switch direction {
        case .forward:
            (.trailing, .leading)
        case .backward:
            (.leading, .trailing)
        }
    }
    
    
    
    // MARK: Inner Objects
    
    public enum AnimationDirection {
        case forward, backward
    }
}
*/
