//
//  EventTimelineView.swift
//  Copairent
//
//  Created by Daniel Hunt on 10/16/24.
//
import Foundation
import SwiftUI
import SwiftData

struct EventTimelineView: View {
    var events: [Event]
    @State private var visibleCount: Int = 50
    @State private var months: [Date] = []

    private let calendar = Calendar.current
    private let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    private var today: Date {
        calendar.startOfDay(for: Date())
    }

    private var visibleEvents: [Event] {
        Array(events.prefix(visibleCount))
    }

    init(events: [Event]) {
        self.events = events
        // Generate dates for ±24 months from current date
        let today = Date()
        _months = State(initialValue: (-24...24).compactMap { monthOffset in
            calendar.date(byAdding: .month, value: monthOffset, to: today)
        })
    }

    private var groupedEvents: [(Date, [Event])] {
        let visibleEvents = events.prefix(visibleCount)
        let grouped = Dictionary(grouping: visibleEvents) { event in
            Calendar.current.startOfDay(for: event.startDate)
        }
        return grouped.sorted { $0.key < $1.key }
    }

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Events")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                Button(action: {}) {
                    Image(systemName: "slider.horizontal.3")
                }
                .foregroundColor(.black)
            }
            .padding([.horizontal, .top])
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(alignment: .leading, spacing: 24) {
                        ForEach(groupedEvents, id: \.0) { date, dayEvents in
                            Section {
                                VStack(spacing: 24) {
                                    DaySectionView(date: date, events: dayEvents)
                                }
                            }
                            .id(date)
                        }

                        if visibleCount < events.count {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .onAppear {
                                    loadMoreContent()
                                }
                        }
                    }
                    .padding(.horizontal)
                    .onAppear {
                        proxy.scrollTo(today, anchor: .top)
                    }
                }
            }
        }
    }

    private func loadMoreContent() {
        let nextBatch = 50
        visibleCount = min(visibleCount + nextBatch, events.count)
    }
}

#Preview {
    let events: [Event] = [
        Event(id: 1, title: "Event 1", details: "Details 1", startDate: Date(), endDate: Date().addingTimeInterval(60 * 30), color: "#0000FF"),
        Event(id: 2, title: "Event 2", details: "Details 2", startDate: Date().addingTimeInterval(60 * 60), endDate: Date().addingTimeInterval(60 * 90), color: "#000FFF")
    ]
    PreviewContainerView {
        EventTimelineView(events: events)
    }
}
