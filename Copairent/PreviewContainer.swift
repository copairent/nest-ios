//
//  PreviewContainer.swift
//  Copairent
//
//  Created by Daniel Hunt on 10/5/24.
//

import Foundation
import SwiftUI
import SwiftData
import OSLog

@MainActor
class PreviewContainer {
    static let shared = PreviewContainer()

    let container: ModelContainer
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "copairent.Copairent", category: "preview")

    private init() {
        let schema = Schema(versionedSchema: AppSchemaV1.self)
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        do {
            container = try ModelContainer(for: schema, configurations: config)
            logger.info("Preview container created successfully")
            populatePreviewData()
        } catch {
            logger.error("Failed to create preview container: \(error.localizedDescription)")
            fatalError("Failed to create preview container: \(error.localizedDescription)")
        }
    }

    private func populatePreviewData() {
        Task {
            // Add your sample data here
            let user = User(id: 1, email: "test@example.com", firstName: "Test", lastName: "User")
            let events: [Event] = [
                Event(id: 1, title: "Event 1", details: "Details 1", startDate: Date(), endDate: Date().addingTimeInterval(60 * 30), color: "#0000FF"),
                Event(id: 2, title: "Event 2", details: "Details 2", startDate: Date().addingTimeInterval(60 * 60), endDate: Date().addingTimeInterval(60 * 90), color: "#000FFF")
            ]
            container.mainContext.insert(user)
            for ev in events {
                container.mainContext.insert(ev)
            }
            do {
                try container.mainContext.save()
                logger.info("Preview data populated successfully")
            } catch {
                logger.error("Failed to save preview data: \(error.localizedDescription)")
            }
        }
    }
}

struct PreviewContainerView<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        content()
            .modelContainer(PreviewContainer.shared.container)
    }
}
