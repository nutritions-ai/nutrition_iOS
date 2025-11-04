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
                    .background(
                        message.isFromUser
                        ? Color.blue.opacity(0.9)
                        : Color(.secondarySystemBackground)
                    )
                    .foregroundColor(
                        message.isFromUser
                        ? .white
                        : .primary
                    )
                    .cornerRadius(15)
            }
            if !message.isFromUser { Spacer() }
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}

#Preview {
    VStack(spacing: 12) {
        MessageBubble(message: ChatMessage(role: "assistant", content: "Xin chào! Tôi có thể giúp gì cho bạn hôm nay?"))
        MessageBubble(message: ChatMessage(role: "user", content: "Mình muốn có thực đơn giảm cân."))
    }
    .padding()
}
