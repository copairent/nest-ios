//
//  MessagesView.swift
//  Copairent
//
//  Created by Daniel Hunt on 6/10/24.
//

import SwiftUI
import SwiftData

struct ConversationRowView: View {

    var body: some View {
        HStack {
            Circle()
                .foregroundColor(Color.gray)
                .frame(width: 40, height: 40)
            VStack(alignment: .leading) {
                Text(conversation.destination.first!.firstName)
                    .font(.headline)
                if conversation.messages.first != nil {
                    Text(conversation.messages.first!.text)
                        .font(.subheadline)
                }
            }
            Spacer()
            if conversation.messages.first != nil {
                VStack(alignment: .leading){
                    Text(convertToDateFormat(inputDate: conversation.sortedMessages.first!.createdAt))
                        .font(.footnote)
                    Spacer()
                }
            }
        }
        .padding()
    }

    func convertToDateFormat(inputDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: inputDate)
    }
}

struct ConversationsView: View {
    @Query
    var conversations: [Conversation]

    var body: some View {
        ScrollView {
            VStack {
                ForEach(conversations) { conversation in
                    ConversationRowView(conversation: conversation)
                }
            }
        }
    }
}

#Preview {
    ConversationsView()
}
