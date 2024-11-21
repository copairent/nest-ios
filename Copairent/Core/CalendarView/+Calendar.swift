//
//  +Calendar.swift
//  Copairent
//
//  Created by Daniel Hunt on 10/16/24.
//

import Foundation

extension Calendar {
    func monthDatesForEvents(_ date: Date) -> [[Date]] {
        guard let monthInterval = self.dateInterval(of: .month, for: date),
              let monthFirstWeek = self.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let monthLastWeek = self.dateInterval(of: .weekOfMonth, for: monthInterval.end - 1)
        else {
            return []
        }

        let weekInterval = DateInterval(start: monthFirstWeek.start, end: monthLastWeek.end)
        var week = weekInterval.start

        var weeks: [[Date]] = []

        while week < weekInterval.end {
            let weekDays = (0...6).compactMap { self.date(byAdding: .day, value: $0, to: week) }
            weeks.append(weekDays)
            week = self.date(byAdding: .weekOfMonth, value: 1, to: week)!
        }

        return weeks
    }
}
