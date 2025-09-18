//
//  DateSelectorView.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 15/09/2025.
//

import SwiftUI


struct DateSelectorView: View {
    
    // MARK: Attributes
    
    @Binding var selectedDate: Date
    var hasData: (Date) -> Bool
    
    @State private var weekSlider: [[Date.WeekDay]] = []
    @State private var currentWeekIndex: Int = 1
    @State private var createWeek: Bool = false
    
    @State private var offsetToRefresh: CGFloat? = nil
    
    @Namespace private var animation
    
    
    
    // MARK: View
    
    var body: some View {
        
        TabView(selection: $currentWeekIndex) {
            ForEach(weekSlider.indices, id: \.self) { index in
                let week = weekSlider[index]
                weekView(week)
                    .padding(.horizontal, 15)
                    .tag(index)
            }
        }
        .padding(.horizontal, -15)
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: 90)
        .onAppear(perform: {
            if weekSlider.isEmpty {
                let currentWeek = Date().fetchWeek()
                
                if let firstDate = currentWeek.first?.date {
                    weekSlider.append(firstDate.createPreviousWeek())
                }
                
                weekSlider.append(currentWeek)
                
                if let lastDate = currentWeek.last?.date {
                    weekSlider.append(lastDate.createNextWeek())
                }
            }
        })
        .onChange(of: currentWeekIndex) { value in
            /// Creating When it reaches first/last Page
            if value == 0 || value == (weekSlider.count - 1) {
                createWeek = true
            }
        }
    }
    
    
    @ViewBuilder
    private func weekView(_ week: [Date.WeekDay]) -> some View {
        HStack(spacing: 0) {
            ForEach(week) { day in
                DateCell(
                    date: day.date,
                    // Keep parameter semantics identical to existing call site
                    hasData: hasData(day.date),
                    selectedDate: $selectedDate,
                    animation: animation
                )
            }
        }
        .background {
            GeometryReader {
                let minX = $0.frame(in: .global).minX
                
                Color.clear
                    .preference(key: OffsetKey.self, value: minX)
                    .onPreferenceChange(OffsetKey.self) { value in
                        /// When the Offset reaches 15 and if the createWeek is toggled then simply generating next set of week
                        if value.rounded() == offsetToRefresh?.rounded() && createWeek {
                            paginateWeek()
                            createWeek = false
                        }
                    }
                    .onAppear {
                        if self.offsetToRefresh == nil {
                            self.offsetToRefresh = minX
                        }
                    }
            }
        }
    }
    
    
    
    // MARK: Methods
    
    func paginateWeek() {
        /// SafeCheck
        if weekSlider.indices.contains(currentWeekIndex) {
            if let firstDate = weekSlider[currentWeekIndex].first?.date, currentWeekIndex == 0 {
                /// Inserting New Week at 0th Index and Removing Last Array Item
                weekSlider.insert(firstDate.createPreviousWeek(), at: 0)
                weekSlider.removeLast()
                currentWeekIndex = 1
            }
            
            if let lastDate = weekSlider[currentWeekIndex].last?.date, currentWeekIndex == (weekSlider.count - 1) {
                /// Appending New Week at Last Index and Removing First Array Item
                weekSlider.append(lastDate.createNextWeek())
                weekSlider.removeFirst()
                currentWeekIndex = weekSlider.count - 2
            }
        }
        
        print(weekSlider.count)
    }
}




@available(iOS 18.0, macOS 15.0, *)
#Preview {
    @Previewable @State var selectedDate = Date()
    
    PreviewScaffold(disablePadding: true) {
        DateSelectorView(selectedDate: $selectedDate) { date in
            if date.isSameDayAs(Date(timeIntervalSince1970: 1758111391)) {
                return false
            }
            return true
        }
        .padding(8)
    }
}
