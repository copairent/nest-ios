//
//  CalendarView.swift
//  Copairent
//
//  Created by Daniel Hunt on 6/10/24.
//

import Foundation
import SwiftUI
import SwiftData


/// View for the Calendar of one or more children. The calendar can scroll through months and display the
/// days of the month as well as the events for each day.
struct CalendarView: View {
    @State private var months: [Date] = []
    @State private var scrollToToday = true

    private let calendar = Calendar.current
    private let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    private var today: Date {
        calendar.startOfDay(for: Date())
    }

    init() {
        // Generate dates for ±24 months from current date
        let today = Date()
        _months = State(initialValue: (-24...24).compactMap { monthOffset in
            calendar.date(byAdding: .month, value: monthOffset, to: today)
        })
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(months, id: \.self) { month in
                        MonthView(date: month)
                            .id(month)
                    }
                }
            }
            .onAppear {
                // Find the current month in our array
                if let currentMonth = months.first(where: { calendar.isDate($0, equalTo: today, toGranularity: .month) }) {
                    // Scroll to current month with animation
                    withAnimation {
                        proxy.scrollTo(currentMonth, anchor: .top)
                    }
                }
            }
        }
    }
}

extension Calendar {
    func generateDates(for dateInterval: DateInterval, matching components: DateComponents = DateComponents()) -> [Date] {
        var dates = [Date]()
        dates.append(dateInterval.start)

        enumerateDates(
            startingAfter: dateInterval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            if let date = date {
                if date < dateInterval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
            }
        }

        return dates
    }
}

#Preview {
    PreviewContainerView {
        CalendarView()
    }
}
