//
//  DateSelectorView.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 28/08/2025.
//

import SwiftUI
import Styles


@available(iOS 26.0, macOS 26.0, *)
struct DateSelectorView: View {
    
    // MARK: Inputs
    
    @EnvironmentObject var console: PreviewConsole
    @Binding var selectedTab: Date
    var hasData: (Date) -> Bool
    
    
    // MARK: State
    
    @State private var calendar: Calendar = .autoupdatingCurrent
    /// Start dates (start of week) for each loaded page, sorted ascending.
    @State private var weekStarts: [Date] = []
    /// The currently visible page (week start).
    @State private var currentWeekStart: Date?
    /// Cache of computed days for each loaded week start.
    @State private var weekCache: [Date: [Date]] = [:]
    
    // How many pages to keep as a safety buffer on each side before we append/prepend more
    private let bufferThreshold = 1
    
    @Namespace private var animation
    
    
    
    // MARK: Init
    
    init(selectedTab: Binding<Date>, hasData: @escaping (Date) -> Bool) {
        self._selectedTab = selectedTab
        self.hasData = hasData
        
        // Initialize current week from the bound date so the first page matches selection
        let cal = Calendar.current
        let start = selectedTab.wrappedValue.startOfWeek(cal)
        self._currentWeekStart = State(initialValue: start)
        self._calendar = State(initialValue: cal)
    }
    
    
    
    // MARK: Body
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                ForEach(weekStarts, id: \.self) { start in
                    weekView(start)
                        .containerRelativeFrame(.horizontal)
                        .id(start)
                }
            }
            .scrollTargetLayout()
        }
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $currentWeekStart)
        .onAppear { initializePagesIfNeeded() }
        .onChange(of: currentWeekStart) { _, _ in ensureBufferAroundCurrent() }
        .onChange(of: selectedTab) { _, newValue in
            // Jump to the week containing the newly selected date
            let weekStart = newValue.startOfWeek(calendar)
            jump(to: weekStart)
        }
    }
    
    
    @ViewBuilder
    private func weekView(_ weekStart: Date) -> some View {
        let days = daysForWeek(start: weekStart)
        HStack(spacing: 0) {
            ForEach(days, id: \.self) { day in
                DateCell(
                    date: day,
                    // Keep parameter semantics identical to existing call site
                    isEmpty: hasData(day),
                    selectedDate: $selectedTab,
                    animation: animation
                )
            }
        }
    }
    
    
    
    // MARK: Paging/Data management
    
    private func initializePagesIfNeeded() {
        guard weekStarts.isEmpty else { return }
        console.append("Truc")
        let base = currentWeekStart ?? selectedTab.startOfWeek(calendar)
        currentWeekStart = base
        let prev = calendar.date(byAdding: .weekOfYear, value: -1, to: base)!.startOfWeek(calendar)
        let next = calendar.date(byAdding: .weekOfYear, value: 1, to: base)!.startOfWeek(calendar)
        var starts = [prev, base, next].sorted()
        // Ensure uniqueness if calendar math ever overlaps (shouldn't, but safe)
        starts = Array(Set(starts)).sorted()
        weekStarts = starts
        // Pre-populate cache for visible pages
        for s in starts { _ = daysForWeek(start: s) }
    }
    
    
    private func ensureBufferAroundCurrent() {
        guard let current = currentWeekStart, let idx = weekStarts.firstIndex(of: current) else { return }
        if idx <= bufferThreshold { prependWeeks(1) }
        if idx >= weekStarts.count - 1 - bufferThreshold { appendWeeks(1) }
    }
    
    
    private func appendWeeks(_ count: Int) {
        guard let last = weekStarts.last else { return }
        var toAppend: [Date] = []
        for i in 1...count {
            if let next = calendar.date(byAdding: .weekOfYear, value: i, to: last)?.startOfWeek(calendar) {
                toAppend.append(next)
            }
        }
        for s in toAppend { if !weekStarts.contains(s) { weekStarts.append(s); _ = daysForWeek(start: s) } }
    }
    
    
    private func prependWeeks(_ count: Int) {
        guard let first = weekStarts.first else { return }
        var toPrepend: [Date] = []
        for i in 1...count {
            if let prev = calendar.date(byAdding: .weekOfYear, value: -i, to: first)?.startOfWeek(calendar) {
                toPrepend.append(prev)
            }
        }
        for s in toPrepend.reversed() { if !weekStarts.contains(s) { weekStarts.insert(s, at: 0); _ = daysForWeek(start: s) } }
    }
    
    
    private func jump(to weekStart: Date) {
        // If target isn't loaded, expand around it minimally then assign scroll position
        if !weekStarts.contains(weekStart) {
            // Build a short sequence around the target to avoid big jumps
            let prev = calendar.date(byAdding: .weekOfYear, value: -1, to: weekStart)!.startOfWeek(calendar)
            let next = calendar.date(byAdding: .weekOfYear, value: 1, to: weekStart)!.startOfWeek(calendar)
            weekStarts = [prev, weekStart, next].sorted()
            for s in weekStarts { _ = daysForWeek(start: s) }
        }
        currentWeekStart = weekStart
    }
    
    
    
    // MARK: Helpers
    private func daysForWeek(start: Date) -> [Date] {
        if let cached = weekCache[start] { return cached }
        let days = (0..<7).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: start)
        }.map { calendar.startOfDay(for: $0) }
        weekCache[start] = days
        return days
    }
}





// MARK: - Small Date helpers
extension Date {
    func startOfWeek(_ calendar: Calendar) -> Date {
        (calendar.dateInterval(of: .weekOfYear, for: self)?.start ?? self).startOfDay(calendar)
    }
    func startOfDay(_ calendar: Calendar) -> Date { calendar.startOfDay(for: self) }
}

/// Retourne trois listes de dates correspondant à :
/// - la semaine précédente,
/// - la semaine contenant `reference`,
/// - la semaine suivante.
///
/// Les dates retournées sont normalisées au début de journée via `calendar.startOfDay(for:)`
/// et respectent la définition locale de la semaine (ex. lundi en France).
func weeksAround(
    reference: Date = Date(),
    calendar: Calendar = .autoupdatingCurrent
) -> (previous: [Date], current: [Date], next: [Date]) {
    let current = weekDates(containing: reference, calendar: calendar)
    let previousRef = calendar.date(byAdding: .weekOfYear, value: -1, to: reference) ?? reference
    let nextRef = calendar.date(byAdding: .weekOfYear, value: 1, to: reference) ?? reference
    let previous = weekDates(containing: previousRef, calendar: calendar)
    let next = weekDates(containing: nextRef, calendar: calendar)
    return (previous, current, next)
}

/// Construit les 7 dates de la semaine contenant `date`, en respectant le `Calendar` fourni.
/// La première date correspond au début de la semaine (selon `calendar`), puis +0…+6 jours.
func weekDates(
    containing date: Date,
    calendar: Calendar
) -> [Date] {
    guard let start = calendar.dateInterval(of: .weekOfYear, for: date)?.start else {
        return []
    }
    return (0..<7).compactMap { offset in
        calendar.date(byAdding: .day, value: offset, to: start)
    }
    .map { calendar.startOfDay(for: $0) }
}





@available(iOS 26.0, macOS 26.0, *)
#Preview {
    @Previewable @State var date = Date()
    
    PreviewScaffold(showPrints: true) {
        DateSelectorView(selectedTab: $date) { date in
            if date == Date() {
                return false
            }
            return false
        }
        .environmentObject(PreviewConsole())
    }
}
