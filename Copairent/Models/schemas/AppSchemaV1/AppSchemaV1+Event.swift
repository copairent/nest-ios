//
//  AppSchemaV1+Event.swift
//  Copairent
//
//  Created by Daniel Hunt on 10/16/24.
//

import Foundation
import SwiftUI
import SwiftData

extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0

        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0

        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0

        } else {
            return nil
        }

        self.init(red: r, green: g, blue: b, opacity: a)
    }
}

extension AppSchemaV1 {
    @Model
    class Event {
        @Attribute(.unique) var id: Int64
        var title: String
        var details: String?
        var startDate: Date
        var endDate: Date
        var colorHex: String
        var lastModified: Date

        @Transient var color: Color {
            Color(hex: colorHex) ?? .gray // Default to gray if the hex is invalid
        }
        @Relationship(inverse: \Calendar.events) var calendar: Calendar?

        init(id: Int64, title: String, details: String?, startDate: Date, endDate: Date, color: String, lastModified: Date = .now) {
            self.id = id
            self.title = title
            self.details = details
            self.startDate = startDate
            self.endDate = endDate
            self.colorHex = color
            self.lastModified = lastModified
        }

        convenience init(event: APIEvent) {
            self.init(
                id: event.id,
                title: event.title,
                details: event.details,
                startDate: event.startDate,
                endDate: event.endDate,
                color: event.colorHex
            )
        }
    }
}

