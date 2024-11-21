//
//  DayCell.swift
//  Copairent
//
//  Created by Daniel Hunt on 10/31/24.
//

import SwiftUI

struct DayCell: View {
    let date: Date

    private let calendar = Calendar.current

    var body: some View {
        VStack {
            Text("\(calendar.component(.day, from: date))")
        }
    }
}

#Preview {
    DayCell(date: Date())
}
