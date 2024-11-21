//
//  AppSchemaV1+Calendar.swift
//  Copairent
//
//  Created by Daniel Hunt on 10/16/24.
//

import Foundation
import SwiftData

extension AppSchemaV1 {
    @Model
    class Calendar {
        @Attribute(.unique) var id: Int64
        var lastSync: Date?
        var primary: Bool
        @Relationship var events: [Event]?
        @Relationship(inverse: \Child.calendar) var child: Child?

        init(id: Int64, primary: Bool = false) {
            self.id = id
            self.primary = primary
        }

        init(id: Int64, events: [Event]) {
            self.id = id
            self.events = events
            self.primary = false
        }
    }
}
