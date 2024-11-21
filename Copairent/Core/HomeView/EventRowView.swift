//
//  EventRowView.swift
//  Copairent
//
//  Created by Daniel Hunt on 11/4/24.
//
import Foundation
import SwiftUI

struct EventRowView: View {
    let event: Event

    private var startTimeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: event.startDate)
    }

    private func timeString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(event.title)
                .font(.subheadline)

            Text("\(timeString(for: event.startDate)) - \(timeString(for: event.endDate))")
                .font(.caption)

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(event.color.opacity(0.2))
        .cornerRadius(8)
    }
}
