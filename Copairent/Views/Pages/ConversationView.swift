//
//  ConversationView.swift
//  Copairent
//
//  Created by Daniel Hunt on 6/11/24.
//

import SwiftUI
import SwiftData

struct ConversationView: View {
    @Binding var conversation: Conversation
    @State var newMessage: String = ""

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    ForEach(conversation.sortedMessages, id: \.self) { message in
                        MessageView(message: message)
                    }
                }
            }
            HStack {
                TextField("Type a message...", text: $newMessage)
                    .textFieldStyle(.roundedBorder)
            }
            .padding()
        }
    }
}

//#Preview(traits: .conversationsSamples) {
//    @Previewable @State var conversation = Conversation(destination: [
//        User(firstName: "Daniel", lastName: "Hunt", email: "daniel@hunt.com", isCurrentUser: true),
//        User(firstName: "Deziree", lastName: "Louder", email: "lleilani@me.com"),
//    ], messages: [])
//    conversation.messages.append(Message(text: "Hello World!", sender: conversation.destination.first!))
//    return ConversationView(conversation: $conversation)
//}
