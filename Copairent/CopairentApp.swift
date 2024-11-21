//
//  CopairentApp.swift
//  Copairent
//
//  Created by Daniel Hunt on 6/10/24.
//

import SwiftUI
import SwiftData
import OSLog
import os

// clear cache: https://vikramios.medium.com/clearing-xcode-cache-e83fbf6c480b

@main
struct CopairentApp: App {

    @StateObject private var networkClient: MockHTTPClient
    @StateObject private var userStateViewModel: UserStateViewModel
    let container: ModelContainer
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "copairent.Copairent", category: "app")

    init() {
        do {
            let schema = Schema(versionedSchema: AppSchemaV1.self)
            let config = ModelConfiguration(isStoredInMemoryOnly: false)
            container = try ModelContainer(for: schema, configurations: config)
            let client = MockHTTPClient(modelContext: container.mainContext)
            let vm = UserStateViewModel(networkClient: client)
            _networkClient = .init(wrappedValue: client)
            _userStateViewModel = .init(wrappedValue: vm)
            logger.info("Successfully initialized model container")
        } catch {
           logger.error("Failed to initialize model container: \(error.localizedDescription)")
           if let swiftDataError = error as? SwiftDataError {
               logger.error("SwiftData error details: \(String(describing: swiftDataError))")
           }
           // Instead of using fatalError, we'll create a fallback in-memory container
           logger.warning("Falling back to in-memory container")
           do {
               let fallbackConfig = ModelConfiguration(isStoredInMemoryOnly: true)
               container = try ModelContainer(for: Schema(versionedSchema: AppSchemaV1.self), configurations: fallbackConfig)
               let client = MockHTTPClient(modelContext: container.mainContext)
               let vm = UserStateViewModel(networkClient: client)
               _networkClient = .init(wrappedValue: client)
               _userStateViewModel = .init(wrappedValue: vm)
               logger.info("Successfully created fallback in-memory container")
           } catch {
               logger.fault("Failed to create fallback container: \(error.localizedDescription)")
               fatalError("Failed to create even a fallback container. App cannot continue.")
           }
        }
        
   }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
            }
        }
        .modelContainer(container)
        .environmentObject(networkClient)
        .environmentObject(userStateViewModel)
    }
}

struct ApplicationSwitcher: View {

    @EnvironmentObject var vm: UserStateViewModel

    var body: some View {
        if (vm.isLoggedIn) {
            AppTabView()
        } else {
            SignInView()
        }

    }
}
