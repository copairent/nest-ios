//
//  MonthView.swift
//  Copairent
//
//  Created by Daniel Hunt on 10/31/24.
//

import SwiftUI

struct MonthView: View {
    let date: Date
    private let calendar = Calendar.current
    private let monthFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM yyyy"
            return formatter
        }()
    var body: some View {
        VStack {
            // Month header
            Text(monthFormatter.string(from: date))
                .font(.title)
                .fontWeight(.bold)
                .padding(.vertical)
            // Weekday headers
            HStack(spacing: 0) {
                ForEach(calendar.shortWeekdaySymbols, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
            }
            // Calendar grid
            let daysInMonth = daysInMonth()
            let columns = Array(repeating: GridItem(.flexible()), count: 7)

            LazyVGrid(columns: columns) {
                ForEach(daysInMonth, id: \.self) { date in
                    if calendar.isDate(date, equalTo: self.date, toGranularity: .month) {
                        DayCell(date: date)
                            .id(date)
                    } else {
                        Color.clear
                            .aspectRatio(1, contentMode: .fill)
                    }
                }
                
            }
            .padding(.horizontal)
        }
        .frame(height: UIScreen.main.bounds.height)
    }

    /// Returns an array of dates for the days in the selected month
    private func daysInMonth() -> [Date] {
        let dateInterval = calendar.dateInterval(of: .month, for: date)!
        return calendar.generateDates(for: dateInterval, matching: DateComponents(hour: 0, minute: 0, second: 0))
    }
}

#Preview {
    MonthView(date: Date())
}
