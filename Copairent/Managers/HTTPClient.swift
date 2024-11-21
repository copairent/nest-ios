//
//  HTTPClient.swift
//  Copairent
//
//  Created by Daniel Hunt on 10/2/24.
//

import Foundation
import SwiftUI
import SwiftData

// MARK: - Network Errors
enum NetworkError: Error {
    case unauthorized
    case authenticationFailed
    case signOutFailed
    case fetchFailed
    case invalidResponse
    case unknown

    var description: String {
        switch self {
        case .unauthorized:
            return "User is not authenticated"
        case .authenticationFailed:
            return "Failed to authenticate user"
        case .signOutFailed:
            return "Failed to sign out user"
        case .fetchFailed:
            return "Failed to fetch data"
        case .invalidResponse:
            return "Invalid response from server"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}

/// Protocol for calling the API. This is a protocol so there can be a MockClient (testing purposes) and a Real Client.
protocol NetworkProtocol {
    /// Signs the user in to the app and stores the token in Keychain.
    /// - Parameters:
    ///   - email: email of the user
    ///   - password: password of the user
    /// - Returns: whether the api call was successful or the error that it encountered.
    func signIn(email: String, password: String) async throws
    /// Signs the user out of the app and removes the token from the User's Keychain
    /// - Returns: The result of the api call (true if successful, false if not) or the error, if any.
    func signOut() async throws
    func fetchChildren()async throws
    func fetchEvents() async throws
    func fetchCalendarEvents(calendarId: Int64) async throws
}

@MainActor
@Observable class MockHTTPClient: NetworkProtocol, ObservableObject {
    var modelContext: ModelContext
    var mockEvents: [Int64:[Event]] = [
        1: [
            Event(id: 0, title: "Event 0", details: "Details 0", startDate: Date().addingTimeInterval(-60*60*24), endDate: Date().addingTimeInterval(-60*60*23), color: "#0000FF"),
            Event(id: 1, title: "Event 1", details: "Details 1", startDate: Date(), endDate: Date().addingTimeInterval(60*30), color: "#0000FF"),
            Event(id: 2, title: "Event 2", details: "Details 2", startDate: Date().addingTimeInterval(60*30), endDate: Date().addingTimeInterval(60*60), color: "#000FFF"),
            Event(id: 3, title: "Event 3", details: "Details 3", startDate: Date().addingTimeInterval(60*60), endDate: Date().addingTimeInterval(60*60*2), color: "#000FFF"),
            Event(id: 4, title: "Event 4", details: "Details 4", startDate: Date().addingTimeInterval(60*60*24), endDate: Date().addingTimeInterval(60*60*25), color: "#000FFF")
        ]
    ]
    var mockChildren: [Child]
    var mockCalendars: [Int64: ChildCalendar]
    private var lastSyncDates: [Int64: Date] = [:]

    // Configurable properties for testing
    var shouldSimulateNetworkDelay = true
    var networkDelay: TimeInterval = 0.5
    var shouldFail = false
    var errorToThrow: Error?

    // MARK: - Keys for UserDefaults
    private let lastSyncDateKeyPrefix = "lastSyncDate_calendar_"

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        var child = Child(id: 1, firstName: "Kai", lastName: "Hunt")
        var calendar = ChildCalendar(id: 1)
        child.calendar = calendar
        mockEvents = [
            1: [
                Event(id: 0, title: "Event 0", details: "Details 0", startDate: Date().addingTimeInterval(-60*60*24), endDate: Date().addingTimeInterval(-60*60*23), color: "#0000FF"),
                Event(id: 1, title: "Event 1", details: "Details 1", startDate: Date(), endDate: Date().addingTimeInterval(60*30), color: "#0000FF"),
                Event(id: 2, title: "Event 2", details: "Details 2", startDate: Date().addingTimeInterval(60*30), endDate: Date().addingTimeInterval(60*60), color: "#000FFF"),
                Event(id: 3, title: "Event 3", details: "Details 3", startDate: Date().addingTimeInterval(60*60), endDate: Date().addingTimeInterval(60*60*2), color: "#000FFF"),
                Event(id: 4, title: "Event 4", details: "Details 4", startDate: Date().addingTimeInterval(60*60*24), endDate: Date().addingTimeInterval(60*60*25), color: "#000FFF")
            ]
        ]
        self.mockChildren = [
            Child(id: 1, firstName: "Kai", lastName: "Hunt")
        ]
        self.mockCalendars = [
            1: ChildCalendar(id: 1)
        ]
        loadLastSyncDates()
    }

    func signIn(email: String, password: String) async throws {
        print("Signing in with email: \(email) and password: \(password)")
        let token = "1234567890"
        let tag = "com.copairent.mock.token"

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: tag
        ]

        let attributes: [String: Any] = [
            kSecValueData as String: token.data(using: .utf8)!
        ]

        print("Adding/Updating token: \(token) to keychain")

        // First, try to update the existing item
        var status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)

        if status == errSecItemNotFound {
            // If the item doesn't exist, add it
            let addQuery = query.merging(attributes) { (_, new) in new }
            status = SecItemAdd(addQuery as CFDictionary, nil)
        }

        print("Status: \(status)")

       guard status == errSecSuccess else {
           throw NetworkError.authenticationFailed
       }
    }

    func signOut() async throws {
        let tag = "com.copairent.mock.token"

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: tag
        ]

        print("Removing token from keychain")

        let status = SecItemDelete(query as CFDictionary)

        print("Status: \(status)")

        // If the item was successfully deleted or it didn't exist, we consider it a successful sign out
        guard status == errSecSuccess || status == errSecItemNotFound else {
            let message = SecCopyErrorMessageString(status, nil) as String? ?? "Unknown error"
            print("Keychain error: \(message)")
            throw NetworkError.authenticationFailed
        }
    }

    // MARK: - Data Fetching Methods
    func fetchChildren() async throws {
        try await simulateNetworkDelay()

        if shouldFail {
            throw errorToThrow ?? NetworkError.fetchFailed
        }

        let children = mockChildren
        for kid in children {
            let kid_id = kid.id
            let descriptor = FetchDescriptor<Child>(
                predicate: #Predicate<Child> { child in
                    child.id == kid_id
                }
            )
            let localChild = try modelContext.fetch(descriptor).first ?? kid
            if localChild.calendar == nil {
                localChild.calendar = mockCalendars[0]
                _ = try modelContext.save()
            }
        }
    }

    func fetchCalendarEvents(calendarId: Int64) async throws {
        try await simulateNetworkDelay()

        if shouldFail {
            throw errorToThrow ?? NetworkError.fetchFailed
        }

        // Get events for the calendar from mock "server"
        let serverEvents = mockEvents[calendarId] ?? []

        // Fetch existing events from SwiftData
        let descriptor = FetchDescriptor<Event>(
            predicate: #Predicate<Event> { event in
                event.calendar?.id == calendarId
            }
        )
        let localEvents = try modelContext.fetch(descriptor)

        // Create dictionary of existing events by ID
        let localEventsDict = Dictionary(uniqueKeysWithValues: localEvents.map { ($0.id, $0) })

        // Update or insert events
        for serverEvent in serverEvents {
            if let existingEvent = localEventsDict[serverEvent.id] {
                // Update existing event if server version is newer
                if serverEvent.lastModified > existingEvent.lastModified {
                    existingEvent.title = serverEvent.title
                    existingEvent.details = serverEvent.details
                    existingEvent.startDate = serverEvent.startDate
                    existingEvent.endDate = serverEvent.endDate
                    existingEvent.colorHex = serverEvent.colorHex
                    existingEvent.lastModified = serverEvent.lastModified
                }
            } else {
                // Insert new event
//                let newEvent = Event(event: serverEvent)
                modelContext.insert(serverEvent)
            }
        }

        // Delete events that no longer exist on server
        let serverEventIds = Set(serverEvents.map { $0.id })
        for localEvent in localEvents {
            if !serverEventIds.contains(localEvent.id) {
                modelContext.delete(localEvent)
            }
        }

        // Save changes
        try modelContext.save()

        // Update last sync date
        await updateLastSyncDate(for: calendarId)
    }

    func fetchEvents() async throws {
        for (calId, _) in mockEvents {
            try await fetchCalendarEvents(calendarId: calId)
        }
    }

    // MARK: - Mock Data Management
    func addMockEvents(_ events: [Event], for calendarId: Int64) {
        mockEvents[calendarId] = events
    }

    func addMockChildren(_ children: [Child]) {
        mockChildren = children
    }

    func clearMockData() {
        mockChildren = []
        mockEvents = [:]
        clearLastSyncDates()
    }

    // MARK: - Sync Date Management
    private func loadLastSyncDates() {
        let defaults = UserDefaults.standard
        lastSyncDates = mockEvents.keys.reduce(into: [:]) { result, calendarId in
            if let date = defaults.object(forKey: lastSyncDateKey(for: calendarId)) as? Date {
                result[calendarId] = date
            }
        }
    }

    private func lastSyncDateKey(for calendarId: Int64) -> String {
        "\(lastSyncDateKeyPrefix)\(calendarId)"
    }

    private func updateLastSyncDate(for calendarId: Int64) async {
        let newDate = Date()
        lastSyncDates[calendarId] = newDate

        await MainActor.run {
            UserDefaults.standard.set(newDate, forKey: lastSyncDateKey(for: calendarId))
        }
    }

    func getLastSyncDate(for calendarId: Int64) -> Date? {
        lastSyncDates[calendarId]
    }

    private func clearLastSyncDates() {
        let defaults = UserDefaults.standard
        lastSyncDates.keys.forEach { calendarId in
            defaults.removeObject(forKey: lastSyncDateKey(for: calendarId))
        }
        lastSyncDates = [:]
    }

    // MARK: - Helper Methods
    private func simulateNetworkDelay() async throws {
        if shouldSimulateNetworkDelay {
            try await Task.sleep(nanoseconds: UInt64(networkDelay * 1_000_000_000))
        }
    }
}

//enum RealHTTPClient: HTTPClient {
//    static func signIn(email: String, password: String) async throws -> Bool {
//        guard let url = URL(string: "https://localhost:8000/account/login") else { fatalError("Missing URL") }
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//
//        let data: [String: Any] = ["email": email, "password": password]
//        let body = try? JSONSerialization.data(withJSONObject: data, options: [])
//
//        request.httpBody = body
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                print(error?.localizedDescription ?? "No data")
//                return
//            }
//            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
//            if let responseJSON = responseJSON as? [String: Any] {
//                print(responseJSON)
//            }
//        }
//
//        task.resume()
//        return True
//    }
//}
