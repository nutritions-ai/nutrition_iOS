//
//  MessageBubble.swift
//  NutritionApp
//
//  Created by 49 on 18/10/25.
//

import SwiftUI

struct MessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isFromUser { Spacer() }
            VStack(alignment: message.isFromUser ? .trailing : .leading) {
                Text(message.content)
                    .padding(10)
                    .background(message.isFromUser ? Color.blue.opacity(0.9) : Color.gray.opacity(0.2))
                    .foregroundColor(message.isFromUser ? .white : .black)
                    .cornerRadius(15)
//                Text(message.time)
//                    .font(.caption2)
//                    .foregroundColor(.gray)
//                    .padding(message.isFromUser ? .trailing : .leading, 10)
            }
            if !message.isFromUser { Spacer() }
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}
