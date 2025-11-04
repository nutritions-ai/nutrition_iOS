//
//  ChatViewModel.swift
//  NutritionApp
//
//  Created by 49 on 18/10/25.
//  Updated by ChatGPT on 25/10/25.
//

import Foundation
import Combine
import UIKit

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
 
// MARK: Extension thêm chức năng chụp ảnh với ghi âm
 
extension ChatViewModel {
    // MARK: - Gửi image
    func uploadImage(_ image: UIImage) async {
        guard let url = URL(string: baseURL) else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }

        messages.append(ChatMessage(role: "user", content: "📸 Gửi một bức ảnh..."))

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"photo.jpg\"\r\n")
        body.append("Content-Type: image/jpeg\r\n\r\n")
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n")

        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: body)
            let response = try JSONDecoder().decode(APIResponse.self, from: data)
            messages.append(ChatMessage(role: "assistant", content: response.response.content))
        } catch {
            messages.append(ChatMessage(role: "assistant", content: "🚫 Lỗi khi tải ảnh: \(error.localizedDescription)"))
        }
    }

    // MARK: - Gửi audio
    func uploadAudio(_ fileURL: URL) async {
        guard let url = URL(string: baseURL) else { return }

        messages.append(ChatMessage(role: "user", content: "🎙 Gửi một đoạn ghi âm..."))

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        let audioData = try? Data(contentsOf: fileURL)
        guard let audioData else { return }

        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"recording.m4a\"\r\n")
        body.append("Content-Type: audio/m4a\r\n\r\n")
        body.append(audioData)
        body.append("\r\n--\(boundary)--\r\n")

        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: body)
            let response = try JSONDecoder().decode(APIResponse.self, from: data)
            messages.append(ChatMessage(role: "assistant", content: response.response.content))
        } catch {
            messages.append(ChatMessage(role: "assistant", content: "🚫 Lỗi khi tải âm thanh: \(error.localizedDescription)"))
        }
    }
}

// MARK: - Model API Response
struct APIResponse: Codable {
    struct ResponseData: Codable {
        let content: String
    }
    let response: ResponseData
}

// MARK: - Data extension sp multipart
private extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

