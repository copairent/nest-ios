//
//  +Date.swift
//  Copairent
//
//  Created by Daniel Hunt on 10/16/24.
//

import Foundation

extension Date {

    
    /// Fetch entire week given date. For example, If I pass in the date 10/16/2024, I expect to receive:
    /// [10/13/2024, 10/14/2024, 10/15/2024, 10/16/2024, 10/17/2024, 10/18/2024, 10/19/2024]
    /// - Parameter date: Input date for which the week is request
    /// - Returns: All the dates of the week that the input date falls on.
    func fetchWeek(_ date: Date = .init()) -> [Date] {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)

        var week: [Date] = []
        let weekDate = calendar.dateInterval(of: .weekOfMonth, for: startDate)!
        let startWeek = weekDate.start

        (0..<7).forEach{ index in
            if let weekDay = calendar.date(byAdding: .day, value: index, to: startWeek) {
                week.append(weekDay)
            }
        }

        return week
    }
}
