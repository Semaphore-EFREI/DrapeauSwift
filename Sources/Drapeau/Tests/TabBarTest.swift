//
//  SwiftUIView.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 02/09/2025.
//

import SwiftUI


// MARK: - Public API

struct DateNavigationView<Item, Content: View>: View {
    typealias PageBuilder = (Item) -> Content
    typealias LoadItem = (Date) -> Item
    typealias HasContent = (Date) -> Bool
    typealias IsItemEmpty = (Item) -> Bool
    
    private let calendar: Calendar
    private let initialDate: Date
    private let page: PageBuilder
    private let loadItem: LoadItem
    private let hasContent: HasContent
    private let isItemEmpty: IsItemEmpty
    
    @State private var selectedDate: Date
    @State private var currentItem: Item?
    
    init(
        calendar: Calendar = .current,
        initialDate: Date = Date(),
        @ViewBuilder page: @escaping PageBuilder,
        loadItem: @escaping LoadItem,
        // hasContent doit être léger/rapide (ex: bool en cache ou comptage d'events)
        hasContent: @escaping HasContent,
        // pour déduire hasContent depuis Item si besoin
        isItemEmpty: @escaping IsItemEmpty
    ) {
        self.calendar = calendar
        self.initialDate = initialDate
        self.page = page
        self.loadItem = loadItem
        self.hasContent = hasContent
        self.isItemEmpty = isItemEmpty
        _selectedDate = State(initialValue: calendar.startOfDay(for: initialDate))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            DateBarWeekPager(
                calendar: calendar,
                selectedDate: $selectedDate,
                hasContent: hasContent
            )
            .padding(.vertical, 8)
            
            Divider()
            
            // Contenu de la journée
            Group {
                Text(selectedDate.description)
                
                if let item = currentItem {
                    page(item)
                } else {
                    ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .animation(.default, value: selectedDate)
        }
        .onAppear {
            currentItem = loadItem(selectedDate)
        }
        .onChange(of: selectedDate) { newDate in
            // Charge seulement quand on change de jour sélectionné
            currentItem = loadItem(newDate)
        }
    }
}

// MARK: - DateBar paginée par semaines

private struct DateBarWeekPager: View {
    let calendar: Calendar
    @Binding var selectedDate: Date
    let hasContent: (Date) -> Bool
    
    // Grande fenêtre de semaines (virtuellement "infinie")
    private let totalWeeks = 10
    @State private var baseWeekStart: Date = Date()
    @State private var selectedWeekIndex: Int = 5
    @State private var isSyncingSelection = false
    
    var body: some View {
        let _ = initializeOnce()
        
        TabView(selection: $selectedWeekIndex) {
            let mid = totalWeeks / 2
            ForEach(0..<totalWeeks, id: \.self) { w in
                let weekStart = weekStart(forOffset: w - mid)
                HStack(spacing: 8) {
                    ForEach(0..<7, id: \.self) { d in
                        let day = calendar.date(byAdding: .day, value: d, to: weekStart)!
                        DayCell(
                            calendar: calendar,
                            date: day,
                            isSelected: isSameDay(day, selectedDate),
                            hasContent: hasContent(day)
                        )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedDate = calendar.startOfDay(for: day)
                        }
                    }
                }
                .padding(.horizontal, 12)
                .tag(w)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: 64)
        .onChange(of: selectedDate) { newValue in
            // Quand on change de jour, s’assurer que la page semaine suit
            guard !isSyncingSelection else { return }
            isSyncingSelection = true
            let start = weekStart(for: newValue)
            selectedWeekIndex = weekIndex(forWeekStart: start)
            DispatchQueue.main.async { isSyncingSelection = false }
        }
    }
    
    // Initialisation base : placer la fenêtre au milieu, à la semaine du jour initial
    private func initializeOnce() {
        if baseWeekStart == Date() || selectedWeekIndex == 0 {
            let today = calendar.startOfDay(for: Date())
            let start = weekStart(for: today)
            baseWeekStart = start
            selectedWeekIndex = weekIndex(forWeekStart: weekStart(for: selectedDate))
        }
    }
    
    private func weekStart(for date: Date) -> Date {
        calendar.dateInterval(of: .weekOfYear, for: date)?.start ?? calendar.startOfDay(for: date)
    }
    
    private func weekStart(forOffset offset: Int) -> Date {
        calendar.date(byAdding: .weekOfYear, value: offset, to: baseWeekStart)!
    }
    
    private func weekIndex(forWeekStart start: Date) -> Int {
        let mid = totalWeeks / 2
        let comps = calendar.dateComponents([.weekOfYear], from: baseWeekStart, to: start)
        return mid + (comps.weekOfYear ?? 0)
    }
    
    private func isSameDay(_ a: Date, _ b: Date) -> Bool {
        calendar.isDate(a, inSameDayAs: b)
    }
}

// MARK: - Cellule d’un jour (styles demandés)

private struct DayCell: View {
    let calendar: Calendar
    let date: Date
    let isSelected: Bool
    let hasContent: Bool
    
    private var isToday: Bool {
        calendar.isDateInToday(date)
    }
    
    // Couleurs selon les règles :
    // - Non sélectionné : aujourd’hui = texte bleu ; avec contenu = noir ; vide = gris
    // - Sélectionné : fond = bleu (si aujourd’hui) / noir (si contenu) / gris (si vide), texte blanc
    private var textColor: Color {
        if isSelected { return .white }
        if isToday { return .blue }
        return hasContent ? .primary : .secondary
    }
    
    private var backgroundColor: Color? {
        guard isSelected else { return nil }
        if isToday { return .blue }
        return hasContent ? .black : .gray
    }
    
    var body: some View {
        VStack(spacing: 4) {
            Text(shortWeekday(date))
                .font(.caption2).fontWeight(.semibold)
            Text(dayNumber(date))
                .font(.headline.monospacedDigit())
        }
        .frame(width: 40, height: 48)
        .foregroundStyle(textColor)
        .background(
            Group {
                if let bg = backgroundColor {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(bg)
                }
            }
        )
        .animation(.default, value: isSelected)
        .accessibilityLabel(accessibilityLabel)
    }
    
    private func dayNumber(_ date: Date) -> String {
        let d = calendar.component(.day, from: date)
        return String(d)
    }
    
    private func shortWeekday(_ date: Date) -> String {
        var fmt = DateFormatter()
        fmt.calendar = calendar
        fmt.locale = .current
        fmt.dateFormat = "EEE" // Lun, Mar, ...
        return fmt.string(from: date).capitalized
    }
    
    private var accessibilityLabel: String {
        let df = DateFormatter()
        df.calendar = calendar
        df.locale = .current
        df.dateStyle = .full
        var base = df.string(from: date)
        if isToday { base += ", aujourd’hui" }
        base += hasContent ? ", a du contenu" : ", vide"
        base += isSelected ? ", sélectionné" : ""
        return base
    }
}

// MARK: - Exemple d’usage

struct Event: Identifiable { let id = UUID(); let title: String }

@available(iOS 26.0, macOS 26.0, *)
struct DemoView: View {
    @State private var store: [Date: [Event]] = {
        // Exemple : aujourd’hui a 2 events, demain vide, hier 1 event
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        return [
            today: [Event(title: "Réunion"), Event(title: "Sport")],
            cal.date(byAdding: .day, value: 5, to: today)!: [Event(title: "Cours")]
        ]
    }()
    
    var body: some View {
        DateNavigationView<[Event], AnyView>(
            page: { items in
                AnyView(
                    List(items) { e in Text(e.title) }
                        .overlay {
                            if items.isEmpty {
                                ContentUnavailableView("Aucune activité", systemImage: "calendar.badge.exclamationmark")
                            }
                        }
                )
            },
            loadItem: { date in
                let day = Calendar.current.startOfDay(for: date)
                return store[day] ?? []
            },
            hasContent: { date in
                let day = Calendar.current.startOfDay(for: date)
                return !(store[day] ?? []).isEmpty
            },
            isItemEmpty: { $0.isEmpty }
        )
        .navigationTitle("Planning")
    }
}



@available(iOS 26.0, macOS 26.0, *)
#Preview {
    DemoView()
}
