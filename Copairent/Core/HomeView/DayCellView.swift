//
//  DayCellView.swift
//  Copairent
//
//  Created by Daniel Hunt on 10/16/24.
//

import SwiftUI

struct DayCellView: View {
    let date: Date
    let isSelected: Bool

    var body: some View {
        Text("\(Calendar.current.component(.day, from: date))")
            .font(.subheadline)
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .background(isSelected ? Circle().foregroundStyle(Color.blue.opacity(0.3)) : Circle().foregroundStyle(Color.clear))
            .foregroundColor(isInCurrentMonth ? .primary : .secondary)
            .cornerRadius(20)
    }

    private var isInCurrentMonth: Bool {
        Calendar.current.component(.month, from: date) == Calendar.current.component(.month, from: Date())
    }
}

#Preview("Not Selected") {
    DayCellView(date: .init(), isSelected: false)
}

#Preview("Selected") {
    DayCellView(date: .init(), isSelected: true)
}
