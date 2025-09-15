//
//  ScrollViewTest.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 29/08/2025.
//

import SwiftUI
import Styles


@available(iOS 26.0, macOS 26.0, *)
struct ScrollViewTest: View {
    
    @EnvironmentObject var metrics: ScreenMetrics
    
    var items: [TabbarWeek] = [.init(mounth: "Septembre", week: [.init(date: 1, day: "L", isToday: true), .init(date: 2, day: "M"), .init(date: 3, day: "M", isFull: false), .init(date: 4, day: "J"), .init(date: 5, day: "V"), .init(date: 6, day: "S", isFull: false), .init(date: 7, day: "D", isFull: false)])]
    @State var firstItemWidth: CGFloat = 0.0
    @State var lastItemWidth: CGFloat = 0.0
    
    
    var body: some View {
        GeometryReader { geo in
            let size = geo.size.width
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: 8) {
                    ForEach(items.indices, id: \.self) { index in
                        let item = items[index]
                        weekView(item)
                        .background(
                            GeometryReader { proxy in
                                Color.clear
                                    .onAppear {
                                        if index == 0 {
                                            self.firstItemWidth = proxy.size.width
                                        } else if index == items.count - 1 {
                                            self.lastItemWidth = proxy.size.width
                                        }
                                    }
                                    .onChange(of: proxy.size.width) { _, new in
                                        if index == 0 {
                                            self.firstItemWidth = new
                                        } else if index == items.count - 1 {
                                            self.lastItemWidth = new
                                        }
                                    }
                            }
                        )
                        .padding(8)
                        //.roundedCorners(style: .round)
                        //.padding(.leading, (size - firstItemWidth) / 2)
                        //.padding(.trailing, (size - lastItemWidth) / 2)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
        }
    }
    
    
    func weekView(_ week: TabbarWeek) -> some View {
        HStack {
            ForEach(week.week, id: \.self) { day in
                VStack(spacing: 2) {
                    Text(day.day)
                        .drapNote()
                    Text("\(day.date)")
                        .drapImportantBody()
                }
                .padding(.top, 8)
                .padding(.bottom, 7)
                .frame(maxWidth: .infinity)
            }
        }
        .frame(width: metrics.width - 16)
    }
    
    
    
    struct TabbarWeek {
        var mounth: String
        var week: [TabbarDate]
    }
    
    struct TabbarDate: Identifiable, Hashable {
        var id = UUID()
        var date: Int
        var day: String
        var isFull: Bool = true
        var isToday: Bool = false
    }
}





@available(iOS 26.0, macOS 26.0, *)
#Preview {
    PreviewScaffold(disablePadding: true) {
        ScrollViewTest()
    }
}
