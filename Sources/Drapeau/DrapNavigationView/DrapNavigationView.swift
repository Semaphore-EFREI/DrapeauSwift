//
//  DrapNavigationView.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 25/08/2025.
//

import SwiftUI
import Styles


@available(iOS 26.0, macOS 26.0, *)
public struct DrapNavigationView<Item: Hashable, TabLabel: View, Content: View>: View {
    
    // MARK: Public API
    
    private let items: [Item]
    @ViewBuilder private let tabLabel: (Item, Bool) -> TabLabel
    @ViewBuilder private let page: (Item) -> Content
    private let navigationTitle: String

    
    // MARK: State
    
    @State private var selection: Item

    
    
    // MARK: Init
    
    public init(
        _ items: [Item],
        initial: Item? = nil,
        navigationTitle: String = "Aujourd'hui",
        @ViewBuilder tabLabel: @escaping (Item, Bool) -> TabLabel,
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        precondition(!items.isEmpty, "DrapNavigationView requires at least one item")
        self.items = items
        self.tabLabel = tabLabel
        self.page = content
        self.navigationTitle = navigationTitle
        self._selection = State(initialValue: initial ?? items[items.startIndex])

        #if os(iOS)
        let montserratSmall = UIFont(name: "Montserrat-Medium", size: 17) ?? UIFont.systemFont(ofSize: 15)
        UINavigationBar.appearance().titleTextAttributes = [.font: montserratSmall]
        #elseif os(macOS)
        let montserratSmall = NSFont(name: "Montserrat-Medium", size: 17) ?? NSFont.systemFont(ofSize: 15)
        UINavigationBar.appearance().titleTextAttributes = [.font: montserratSmall]
        #endif
    }

    
    
    // MARK: Body
    
    public var body: some View {
        TabView(selection: $selection) {
            ForEach(items, id: \.self) { item in
                NavigationStack {
                    ScrollView {
                        page(item)
                            .tag(item)
                    }
                    .navigationTitle(navigationTitle)
                    .toolbar { toolbarLargeTitle }
                }
            }
        }
        .ignoresSafeArea()
        .tabViewStyle(.page(indexDisplayMode: .never))
    }


    // MARK: Toolbar (Large Title with scrollable, centered tabs)
    
    private var toolbarLargeTitle: some ToolbarContent {
        ToolbarItem(placement: .largeTitle) {
            VStack(spacing: 16) {
                Image(systemName: "31.calendar")
                    .font(.system(size: 36, weight: .medium))
                
                _ScrollableCenteredTabs(
                    items: items,
                    selection: $selection,
                    tabLabel: tabLabel
                )
            }
            .padding(.vertical, 10)
            .padding(.horizontal, -16) // compense le padding par défaut du ToolbarItem
        }
    }
}





// MARK: - Scrollable, centered tab strip
private struct _ScrollableCenteredTabs<Item: Hashable, Label: View>: View {
    let items: [Item]
    @Binding var selection: Item
    @ViewBuilder var tabLabel: (Item, Bool) -> Label

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    // Spacers pour centrer les extrémités
                    Color.clear.frame(width: 100, height: 1).id("_leading")
                    ForEach(items, id: \.self) { item in
                        _TabButton(
                            isSelected: selection == item
                        ) {
                            tabLabel(item, selection == item)
                        }
                        .id(item)
                        .onTapGesture { withAnimation(.snappy) { selection = item } }
                    }
                    Color.clear.frame(width: 100, height: 1).id("_trailing")
                }
                .padding(.horizontal, 16)
            }
            .onAppear { center(on: selection, in: proxy) }
            .onChange(of: selection) { newValue in center(on: newValue, in: proxy) }
        }
    }

    private func center(on id: Item, in proxy: ScrollViewProxy) {
        // On tente de centrer sur l’élément; si indisponible (au tout début), on tombera en no-op.
        DispatchQueue.main.async {
            withAnimation(.snappy) { proxy.scrollTo(id, anchor: .center) }
        }
    }
}



private struct _TabButton<Label: View>: View {
    let isSelected: Bool
    @ViewBuilder var label: () -> Label

    var body: some View {
        label()
            .contentShape(Rectangle())
            .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}





// MARK: - Preview
@available(iOS 26.0, macOS 26.0, *)
#Preview {
    let days = (-5...5).map { offset in
        Calendar.current.date(byAdding: .day, value: offset, to: Date())!.timeIntervalSince1970.rounded() // Hashable ID via Double
    }
    
    return PreviewScaffold(disablePadding: true) {
        DrapNavigationView(days, initial: days[5]) { item, isSelected in
            let date = Date(timeIntervalSince1970: item)
            Text(date.formatted(date: .abbreviated, time: .omitted))
                .drapTitle()
                .foregroundStyle(isSelected ? Color.drapPrimaryText : Color.drapQuaternaryText)
        } content: { item in
            let date = Date(timeIntervalSince1970: item)
            VStack(spacing: 24) {
                Text("Contenu du \(date.formatted(date: .complete, time: .omitted))")
                Rectangle().frame(width: 120, height: 800)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    //return Text("Hello")
}
