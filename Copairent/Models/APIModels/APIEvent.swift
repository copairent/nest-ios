//
//  APIEvent.swift
//  Copairent
//
//  Created by Daniel Hunt on 10/22/24.
//

import Foundation

struct APIEvent: Codable {
    let id: Int64
    let title: String
    let details: String?
    let startDate: Date
    let endDate: Date
    let colorHex: String
    let lastModified: Date
}
