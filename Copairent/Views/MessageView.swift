//
//  MessageView.swift
//  Copairent
//
//  Created by Daniel Hunt on 6/11/24.
//

import SwiftUI
import SwiftData

struct MessageView: View {
    var message: Message

    var displayMessage: some View {
        Text(message.text)
            .padding(10)
            .foregroundColor(message.sender.isCurrentUser ? Color.white : Color.black)
            .background(message.sender.isCurrentUser ? Color.blue : Color(UIColor.systemGray6 ))
            .cornerRadius(10)
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            if message.sender.isCurrentUser{
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40, alignment: .center)
                    .cornerRadius(20)
            } else {
                Spacer()
            }
            displayMessage
            if message.sender.isCurrentUser {
                Spacer()
            }
        }
        .padding()
    }
}

//#Preview(traits: .conversationsSamples) {
//    @Previewable @Query var conversation: [Conversation]
//    MessageView(message: conversation.first!.messages.first!)
//}
