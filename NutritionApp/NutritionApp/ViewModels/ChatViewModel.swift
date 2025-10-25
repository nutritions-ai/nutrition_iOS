//
//  ChatViewModel.swift
//  NutritionApp
//
//  Created by 49 on 18/10/25.
//

import Foundation
import Combine

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var userInput: String = ""
    
    let baseURL = "http://127.0.0.1:8000/chat" // Replace with your backend address
    
    func extractProfile() -> Profile {
        if let savedData = UserDefaults.standard.data(forKey: "UserProfile") {
            do {
                let profileDecode = try JSONDecoder().decode(Profile.self, from: savedData)
                return profileDecode
            } catch {
                print("❌ Lỗi giải mã dữ liệu:", error)
            }
        } else {
            print("⚠️ Chưa có dữ liệu trong UserDefaults")
        }
        return Profile(height: 0, weight: 0, gender: "Nam", age: 0)
    }
    
    func sendMessage() async {
        let input = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !input.isEmpty else { return }
        
        // Add user message to chat
        let userMsg = ChatMessage(role: "user", content: input)
        messages.append(userMsg)
        userInput = ""
        
        var userData = extractProfile()
        
        // Prepare request body
        let requestBody: [String: Any] = [
            "message": input,
            "user_data": ["height":userData.height, "weight":userData.weight, "gender":userData.gender, "age":userData.age]  // You can later fill real data if needed
        ]
        
        guard let url = URL(string: baseURL) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            print("Received data: \(String(data: data, encoding: .utf8) ?? "(binary data)")")
            
            // Parse backend response
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let response = json["response"] as? [String: Any],
               let assistantContent = response["content"] as? String {
                
                let assistantMsg = ChatMessage(role: "assistant", content: assistantContent)
                messages.append(assistantMsg)
            } else {
                let errorMsg = ChatMessage(role: "assistant", content: "⚠️ Could not parse response.")
                messages.append(errorMsg)
            }
        } catch {
            let errorMsg = ChatMessage(role: "assistant", content: "🚫 Network error: \(error.localizedDescription)")
            messages.append(errorMsg)
        }
    }
}
