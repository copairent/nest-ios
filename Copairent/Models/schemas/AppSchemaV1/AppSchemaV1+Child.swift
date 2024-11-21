//
//  AppSchemaV1+Child.swift
//  Copairent
//
//  Created by Daniel Hunt on 10/3/24.
//

import Foundation
import SwiftData

extension AppSchemaV1 {
    @Model
    class Child {
        @Attribute(.unique) var id: Int
        var firstName: String
        var lastName: String
        @Relationship var calendar: Calendar?

        init(id: Int, firstName: String, lastName: String) {
            self.id = id
            self.firstName = firstName
            self.lastName = lastName
        }
    }
}
