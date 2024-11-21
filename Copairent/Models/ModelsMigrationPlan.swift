//
//  ModelsMigrationPlan.swift
//  Copairent
//
//  Created by Daniel Hunt on 6/12/24.
//

import SwiftData

enum ModelsMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [AppSchemaV1.self]
    }

    static var stages: [MigrationStage] {
        []
    }
}
