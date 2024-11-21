//
//  HomeView.swift
//  Copairent
//
//  Created by Daniel Hunt on 10/29/24.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @EnvironmentObject private var networkClient: MockHTTPClient
    @Query private var events: [Event]

    var body: some View {
        EventTimelineView(events: events)
            .onAppear {
                Task {
                    try await networkClient.fetchEvents()
                }
            }
    }
}

#Preview {
    HomeView()
}
