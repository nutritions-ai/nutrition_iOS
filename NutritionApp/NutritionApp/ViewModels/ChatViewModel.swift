//
//  ChatViewModel.swift
//  NutritionApp
//
//  Created by 49 on 18/10/25.
//  Updated by ChatGPT on 25/10/25.
//

import Foundation
import Combine

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var userInput: String = ""
    
    private let baseURL = "http://127.0.0.1:8000/chat" // Replace with your backend address
    
    init() {
        messages = [
            ChatMessage(role: "assistant", content: "Trợ lý: Xin chào! Tôi là Trợ lý Sức khỏe của bạn 👩‍⚕️. Tôi sẽ giúp bạn kiểm tra thông tin cơ bản để lên kế hoạch ăn uống phù hợp. Trước hết, bạn có thể cho tôi biết giới tính của bạn được không?")
        ]
    }
    
    func sendMessage() async {
        let input = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !input.isEmpty else { return }
        
        let userMsg = ChatMessage(role: "user", content: input)
        messages.append(userMsg)
        userInput = ""
        
        let requestBody: [String: Any] = [
            "message": input,
            "user_data": [:]
        ]
        
        guard let url = URL(string: baseURL) else {
            messages.append(ChatMessage(role: "assistant", content: "⚠️ URL không hợp lệ."))
            return
        }
        
        do {
            let responseDict = try await APIClient.shared.sendRequest(to: url, method: "POST", body: requestBody)
            
            if let response = responseDict["response"] as? [String: Any],
               let assistantContent = response["content"] as? String {
                messages.append(ChatMessage(role: "assistant", content: assistantContent))
            } else {
                messages.append(ChatMessage(role: "assistant", content: "⚠️ Could not parse response."))
            }
        } catch {
            messages.append(ChatMessage(role: "assistant", content: "🚫 Network error: \(error.localizedDescription)"))
        }
    }
}
