//
//  AppSchemaV1+User.swift
//  Copairent
//
//  Created by Daniel Hunt on 10/3/24.
//

import Foundation
import SwiftData

extension AppSchemaV1 {
    @Model
    class User {
        @Attribute(.unique) var id: Int
        var email: String?
        var firstName: String
        var lastName: String

        init(id: Int, email: String, firstName: String, lastName: String) {
            self.id = id
            self.email = email
            self.firstName = firstName
            self.lastName = lastName
        }

        init (id: Int, firstName: String, lastName: String) {
            self.id = id
            self.email = nil
            self.firstName = firstName
            self.lastName = lastName
        }
    }
}
