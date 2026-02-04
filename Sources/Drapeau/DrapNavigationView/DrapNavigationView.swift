//
//  DrapNavigationView.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 25/08/2025.
//

import SwiftUI
import Styles


// TODO: Changer ce nom
@available(iOS 26.0, macOS 26.0, *)
public struct DrapNavigationView<Content: View>: View {
    
    // MARK: Public API
    
    @ViewBuilder private let page: (Date) -> Content
    private let hasData: (Date) -> Bool
    private let refreshAction: () -> Void
    
    
    // MARK: State
    
    @State private var selection = Date()
    
    
    
    // MARK: Init
    
    public init(
        @ViewBuilder content: @escaping (Date) -> Content,
        hasData: @escaping (Date) -> Bool,
        refreshAction: @escaping () -> Void
    ) {
        self.page = content
        self.hasData = hasData
        self.refreshAction = refreshAction
        
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
        NavigationStack {
            ZStack {
                Color.drapPrimaryBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    page(selection)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .refreshable {
                    <#code#>
                }
                .navigationTitle(fullDate)
                .toolbar {
                    ToolbarItem(placement: .largeTitle) {
                        VStack(spacing: 0) {
                            // Mois et année
                            HStack {
                                Text(selectedMonth)
                                
                                Text(selectedYear)
                                    .foregroundStyle(Color.drapSecondaryText)
                            }
                            .padding(.top)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .drapPageTitle()
                            
                            // Sélecteur de date
                            DateSelectorView(selectedDate: $selection) { date in
                                hasData(date)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    // MARK: Computed Properties
    
    var selectedMonth: String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "LLLL"
        return formatter.string(from: selection).capitalized
    }
    
    var selectedYear: String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "yyyy"
        return formatter.string(from: selection).capitalized
    }
    
    var fullDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: selection)
    }
}



// MARK: - Preview
@available(iOS 26.0, macOS 26.0, *)
#Preview {
    PreviewScaffold(disablePadding: true) {
        DrapNavigationView { date in
            VStack(spacing: 24) {
                Text("Contenu du \(date.formatted(date: .complete, time: .omitted))")
                Rectangle().frame(width: 120, height: 800)
            }
            //.frame(maxWidth: .infinity, maxHeight: .infinity)
        } hasData: { date in
            return date.isSameDayAs(Date(timeIntervalSince1970: 1758317975))
        } refreshAction: {
            print("")
        }
    }
    
    //return Text("Hello")
}
