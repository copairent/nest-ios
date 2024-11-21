//
//  DaySectionView.swift
//  Copairent
//
//  Created by Daniel Hunt on 11/4/24.
//
import Foundation
import SwiftUI
import Observation

struct DaySectionView: View {
    let date: Date
    let events: [Event]

    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EE\n d"
        return formatter.string(from: date)
    }

    var body: some View {
        HStack(alignment: .top, spacing: 32) {
            Text(dateString)
                .font(.caption)
                .foregroundColor(.gray)
                .frame(width: 32)
            VStack {
                ForEach(events, id: \.id) { event in
                    EventRowView(event: event)
                }
            }
        }
    }
}
