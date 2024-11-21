//
//  AppSchemaV1.swift
//  Copairent
//
//  Created by Daniel Hunt on 10/3/24.
//

import Foundation
import SwiftData

enum AppSchemaV1: VersionedSchema {
    static var versionIdentifier: Schema.Version {
        Schema.Version(1, 0, 0)
    }

    static var models: [any PersistentModel.Type] {
        [User.self, Child.self]
    }
}
