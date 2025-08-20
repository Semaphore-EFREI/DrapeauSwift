//
//  ContextToolbarParser.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 14/08/2025.
//

import SwiftUI



// MARK: - Placement

public enum ContextToolbarPlacement {
    case leading, trailing
}



// MARK: - Élément Effacé

struct ErasedContextToolbarItem: Identifiable, Equatable {
    let id: AnyHashable
    let placement: ContextToolbarPlacement
    let makeBody: () -> AnyView

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id && lhs.placement == rhs.placement
    }
}



// MARK: - PreferenceKey

struct ContextToolbarPreferenceKey: PreferenceKey {
    static var defaultValue: [ErasedContextToolbarItem] { [] }

    static func reduce(value: inout [ErasedContextToolbarItem], nextValue: () -> [ErasedContextToolbarItem]) {
        value.append(contentsOf: nextValue())
    }
}



// MARK: - Protocole Content

/// Contrat minimal : tout contenu de toolbar sait "se collecter" en items effacés.
protocol ContextToolbarContent {
    associatedtype Body: ContextToolbarContent
    @ContextToolbarContentBuilder var body: Body { get }
    
    func _collect(into items: inout [ErasedContextToolbarItem])
}

// Par défaut, un composite délègue à son `body`.
extension ContextToolbarContent {
    func _collect(into items: inout [ErasedContextToolbarItem]) {
        body._collect(into: &items)
    }
}



// MARK: - Terminaux et composites

/// Élément terminal "vide"
struct ContextToolbarEmpty: ContextToolbarContent {
    typealias Body = ContextToolbarEmpty
    var body: ContextToolbarEmpty { self }
    func _collect(into items: inout [ErasedContextToolbarItem]) {}
}


/// Élément terminal "item" (un vrai bouton/label/etc.)
fileprivate struct ContextToolbarItem<Label: View>: ContextToolbarContent {
    typealias Body = ContextToolbarEmpty

    let id: AnyHashable
    let placement: ContextToolbarPlacement
    @ViewBuilder var label: Label

    init(id: AnyHashable = UUID(), placement: ContextToolbarPlacement, @ViewBuilder label: () -> Label) {
        self.id = id
        self.placement = placement
        self.label = label()
    }

    var body: ContextToolbarEmpty { ContextToolbarEmpty() }

    func _collect(into items: inout [ErasedContextToolbarItem]) {
        items.append(ErasedContextToolbarItem(
            id: id,
            placement: placement,
            makeBody: { AnyView(label) }
        ))
    }
}


/// Élément terminal "bouton"
public struct ContextToolbarButton: ContextToolbarContent {
    typealias Body = ContextToolbarEmpty
    
    let id: AnyHashable
    let placement: ContextToolbarPlacement
    @ViewBuilder var label: DrapButton<ActionBarDrapButtonStyle>
    
    init(id: AnyHashable = UUID(), placement: ContextToolbarPlacement, @ViewBuilder label: () -> DrapButton<ActionBarDrapButtonStyle>) {
        self.id = id
        self.placement = placement
        self.label = label()
    }
    
    var body: ContextToolbarEmpty { ContextToolbarEmpty() }
    
    func _collect(into items: inout [ErasedContextToolbarItem]) {
        items.append(ErasedContextToolbarItem(
            id: id,
            placement: placement,
            makeBody: { AnyView(label) }
        ))
    }
}



/// Composite binaire (équivalent conceptuel d’un _TupleView<Left, Right>)
struct ContextToolbarPair<Left: ContextToolbarContent, Right: ContextToolbarContent>: ContextToolbarContent {
    let left: Left
    let right: Right

    var body: some ContextToolbarContent { left; right }

    func _collect(into items: inout [ErasedContextToolbarItem]) {
        left._collect(into: &items)
        right._collect(into: &items)
    }
}


/// Composite pour optionnels (if let / ?)
struct ContextToolbarOptional<Wrapped: ContextToolbarContent>: ContextToolbarContent {
    let wrapped: Wrapped?

    var body: some ContextToolbarContent {
        if let w = wrapped { w } else { ContextToolbarEmpty() }
    }

    func _collect(into items: inout [ErasedContextToolbarItem]) {
        if let w = wrapped { w._collect(into: &items) }
    }
}


/// Composite pour if/else
struct ContextToolbarEither<First: ContextToolbarContent, Second: ContextToolbarContent>: ContextToolbarContent {
    enum Storage { case first(First), second(Second) }
    let storage: Storage

    var body: some ContextToolbarContent {
        switch storage {
        case .first(let f): f
        case .second(let s): s
        }
    }

    func _collect(into items: inout [ErasedContextToolbarItem]) {
        switch storage {
        case .first(let f):  f._collect(into: &items)
        case .second(let s): s._collect(into: &items)
        }
    }
}


/// Composite pour tableaux (boucles)
struct ContextToolbarArray<Element: ContextToolbarContent>: ContextToolbarContent {
    let elements: [Element]
    
    var body: some ContextToolbarContent {
        if let first = elements.first {
            ContextToolbarPair(left: first, right: ContextToolbarArray(elements: Array(elements.dropFirst())))
        } else {
            ContextToolbarEmpty()
        }
    }

    func _collect(into items: inout [ErasedContextToolbarItem]) {
        for e in elements { e._collect(into: &items) }
    }
}



// MARK: - Result builder

@resultBuilder
struct ContextToolbarContentBuilder {
    // 0 éléments
    static func buildBlock() -> ContextToolbarEmpty { ContextToolbarEmpty() }

    // 1 élément
    static func buildBlock<C1: ContextToolbarContent>(_ c1: C1) -> C1 { c1 }

    // 2 éléments
    static func buildBlock<C1: ContextToolbarContent, C2: ContextToolbarContent>(_ c1: C1, _ c2: C2)
        -> ContextToolbarPair<C1, C2> { ContextToolbarPair(left: c1, right: c2) }

    // 3 éléments
    static func buildBlock<C1: ContextToolbarContent, C2: ContextToolbarContent, C3: ContextToolbarContent>(
        _ c1: C1, _ c2: C2, _ c3: C3
    ) -> ContextToolbarPair<ContextToolbarPair<C1, C2>, C3> {
        ContextToolbarPair(left: ContextToolbarPair(left: c1, right: c2), right: c3)
    }

    // 4 éléments
    static func buildBlock<C1: ContextToolbarContent, C2: ContextToolbarContent, C3: ContextToolbarContent, C4: ContextToolbarContent>(
        _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4
    ) -> ContextToolbarPair<ContextToolbarPair<C1, C2>, ContextToolbarPair<C3, C4>> {
        ContextToolbarPair(left: ContextToolbarPair(left: c1, right: c2),
                      right: ContextToolbarPair(left: c3, right: c4))
    }

    // Optionnels
    static func buildOptional<C: ContextToolbarContent>(_ c: C?) -> ContextToolbarOptional<C> {
        ContextToolbarOptional(wrapped: c)
    }

    // if/else
    static func buildEither<First: ContextToolbarContent, Second: ContextToolbarContent>(first: First)
        -> ContextToolbarEither<First, Second> { ContextToolbarEither(storage: .first(first)) }

    static func buildEither<First: ContextToolbarContent, Second: ContextToolbarContent>(second: Second)
        -> ContextToolbarEither<First, Second> { ContextToolbarEither(storage: .second(second)) }

    // Boucles
    static func buildArray<C: ContextToolbarContent>(_ components: [C]) -> ContextToolbarArray<C> {
        ContextToolbarArray(elements: components)
    }
}



// MARK: - Modificateur .myToolbar (émet des préférences)

struct ContextToolbarModifier<C: ContextToolbarContent>: ViewModifier {
    private let collected: [ErasedContextToolbarItem]

    init(@ContextToolbarContentBuilder content: () -> C) {
        var tmp: [ErasedContextToolbarItem] = []
        content()._collect(into: &tmp)
        self.collected = tmp
    }

    func body(content: Content) -> some View {
        content.preference(key: ContextToolbarPreferenceKey.self, value: collected)
    }
}

extension View {
    func contextToolbar<C: ContextToolbarContent>(@ContextToolbarContentBuilder _ content: () -> C) -> some View {
        modifier(ContextToolbarModifier(content: content))
    }
}



// MARK: - Hôte (collecte et rend la barre)

// Doit être la ContextWindow
struct ContextNavigationHost<Content: View>: View {
    let content: Content
    @State private var items: [ErasedContextToolbarItem] = []

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack(alignment: .top) {
            content
                .onPreferenceChange(ContextToolbarPreferenceKey.self) { value in
                    items = value
                }
                .padding(.top, 52)

            // Cette partie doit être la ContextToolbar (avec des
            HStack {
                HStack(spacing: 8) {
                    ForEach(items.filter { $0.placement == .leading }) { it in it.makeBody() }
                }
                Spacer()
                HStack(spacing: 8) {
                    ForEach(items.filter { $0.placement == .trailing }) { it in it.makeBody() }
                }
            }
            .frame(height: 52)
            .padding(.horizontal)
            .background(.thinMaterial)
            .overlay(Divider(), alignment: .bottom)
        }
    }
}



// MARK: - Démo

/*
struct DemoContextToolbar: View {
    @State private var count = 0
    @State private var on = false
    
    var body: some View {
        VStack(spacing: 16) {
            Text("En dehors du host : ceci ne sera pas collecté")
                .font(.footnote)
                .foregroundStyle(.secondary)
            
            // ❌ En dehors du host : la préférence n'atteint pas l’hôte
            Color.clear
                .contextToolbar {
                    ContextToolbarItem(placement: .trailing) {
                        Button("Ghost") { count += 1 }
                    }
                }
            
            Divider()
            
            // ✅ À l’intérieur : items collectés et rendus
            ContextNavigationHost {
                List(0..<8, id: \.self) { i in
                    Text("Ligne \(i)")
                }
                .contextToolbar {
                    ContextToolbarItem(placement: .leading) {
                        Button("Back") { /* ... */ }
                    }
                    if count % 2 == 0 {
                        ContextToolbarItem(placement: .trailing) {
                            Button("+\(count)") { count += 1 }
                        }
                    } else {
                        ContextToolbarItem(placement: .trailing) {
                            Button("Reset") { count = 0 }
                        }
                    }
                }
            }
        }
        .padding()
    }
}
*/
