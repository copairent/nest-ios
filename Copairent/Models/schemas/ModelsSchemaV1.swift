//
//  ModelsV1.swift
//  Copairent
//
//  Created by Daniel Hunt on 6/12/24.
//

import Foundation
import SwiftData

enum ModelsSchemaV1: VersionedSchema {
    static var versionIdentifier: Schema.Version {
        Schema.Version(1, 0, 0)
    }

    static var models: [any PersistentModel.Type] {
        [User.self, Conversation.self, Message.self]
    }

    @Model
    class User {
        var id: String?
        var firstName: String
        var lastName: String
        var email: String
        var isCurrentUser: Bool = false
        @Relationship(inverse: \Conversation.destination) var conversations: [Conversation] = [Conversation]()

        init(firstName: String, lastName: String, email: String) {
            self.firstName = firstName
            self.lastName = lastName
            self.email = email
        }

        init(firstName: String, lastName: String, email: String, isCurrentUser: Bool) {
            self.firstName = firstName
            self.lastName = lastName
            self.email = email
            self.isCurrentUser = isCurrentUser
        }

        init(id: String, firstName: String, lastName: String, email: String, isCurrentUser: Bool) {
            self.id = id
            self.firstName = firstName
            self.lastName = lastName
            self.email = email
            self.isCurrentUser = isCurrentUser
        }
    }

    @Model
    class Conversation {
        var id: Int?
        @Relationship var destination: [User] = [User]()
        var createdAt: Date
        @Relationship(deleteRule: .cascade, inverse: \Message.conversation) var messages = [Message]()
        var sortedMessages: [Message] {
            return messages.sorted(by: { $0.createdAt < $1.createdAt })
        }

        init(destination: [User]) {
            self.destination = destination
            self.createdAt = Date()
        }

        init(destination: [User], messages: [Message]){
            self.messages = messages
            self.destination = destination
            self.createdAt = Date()
        }
    }

    @Model
    class Message {
        var id: Int?
        var text: String
        var sender: User
        var createdAt: Date = Date()
        var updatedAt: Date = Date()
        var isRead: Bool
        var isDeleted: Bool
        var conversation: Conversation?

        init(text: String, sender: User, createdAt: Date, updatedAt: Date, isRead: Bool, isDeleted: Bool, conversation: Conversation) {
            self.text = text
            self.sender = sender
            self.createdAt = createdAt
            self.updatedAt = updatedAt
            self.isRead = isRead
            self.isDeleted = isDeleted
            self.conversation = conversation
        }

        init(text: String, sender: User) {
            self.text = text
            self.sender = sender
            self.isRead = false
            self.isDeleted = false
        }

        init(text: String, sender: User, conversation: Conversation) {
            self.text = text
            self.sender = sender
            self.isRead = false
            self.isDeleted = false
            self.conversation = conversation
        }
    }
}
