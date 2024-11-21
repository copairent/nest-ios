//
//  UsersSchemaV1.swift
//  Copairent
//
//  Created by Daniel Hunt on 10/2/24.
//

import Foundation
import SwiftData

enum UsersSchemaV1: VersionedSchema {
    static var versionIdentifier: Schema.Version {
        Schema.Version(1, 0, 0)
    }

    

    @Model
    class User {
        var id: String?
        var firstName: String
        var lastName: String
        var email: String?

        init(firstName: String, lastName: String) {
            self.firstName = firstName
            self.lastName = lastName
        }

        init(firstName: String, lastName: String, email: String) {
            self.firstName = firstName
            self.lastName = lastName
            self.email = email
        }

        init(id: String, firstName: String, lastName: String, email: String) {
            self.id = id
            self.firstName = firstName
            self.lastName = lastName
            self.email = email
        }
    }
}
