//
//  APIClient.swift
//  NutritionApp
//
//  Created by DaoNA3 on 25/10/25.
//

import Foundation
import SwiftUI

enum APIClientError: Error, LocalizedError {
    case badURL
    case badResponseStatus(Int)
    case noData
    case invalidJSON
    case serializationError(Error)
    
    var errorDescription: String? {
        switch self {
        case .badURL: return "Không tồn tại URL"
        case .badResponseStatus(let code): return "Lỗi mã HTTP: \(code)"
        case .noData: return "Không có dữ liệu trả về"
        case .invalidJSON: return "Sai định dạng. Dữ liệu trả về không phải là JSON"
        case .serializationError(let error): return "Không thể chuyển đổi dữ liệu: \(error.localizedDescription)"
        }
    }
}

final class APIClient {
    private let session: URLSession
    private let timeout: TimeInterval
    
    static let shared = APIClient()
        
    init(session: URLSession = .shared, timeout: TimeInterval = 20.0) {
        self.session = session
        self.timeout = timeout
    }
    
    func sendRequest(to url: URL,
                     method: String,
                     body: [String: Any]? = nil) async throws -> [String: Any] {
        
        var request = URLRequest(url: url)
        request.httpMethod = method.uppercased()
        request.timeoutInterval = timeout
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                throw APIClientError.serializationError(error)
            }
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let http = response as? HTTPURLResponse else {
            throw APIClientError.noData
        }
        guard (200...299).contains(http.statusCode) else {
            throw APIClientError.badResponseStatus(http.statusCode)
        }
        guard data.count > 0 else {
            throw APIClientError.noData
        }
        
        let obj = try JSONSerialization.jsonObject(with: data, options: [])
        guard let dict = obj as? [String: Any] else {
            throw APIClientError.invalidJSON
        }
        
        return dict
    }
    
    func sendHealthAnalysis(profile: UserProfile) async throws -> AnalyzeResult {
        guard let url = URL(string: "http://127.0.0.1:8000/analyze-health") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        // Helper to add text fields
        func addFormField(_ name: String, _ value: String) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }

        // Helper to add image fields
        func addImageField(_ name: String, _ image: UIImage?) {
            guard let image = image,
                  let imageData = image.jpegData(compressionQuality: 0.8) else { return }

            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(name).jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }

        // Add all fields
        addFormField("name", profile.name)
        addFormField("age", profile.age)
        addFormField("weight", profile.weight)
        addFormField("height", profile.height)
        addImageField("blood_test", profile.bloodTest)
        addImageField("urine_test", profile.urineTest)

        // Close boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            let status = (response as? HTTPURLResponse)?.statusCode ?? -1
            throw NSError(domain: "HTTP Error", code: status)
        }
//        if let jsonData = analyze_result.data(using: .utf8) {
//            do {
//                let result = try JSONDecoder().decode(AnalyzeResult.self, from: jsonData)
//                return result
//            } catch {
//                throw error
//            }
//        }
        do {
            let result = try JSONDecoder().decode(AnalyzeResult.self, from: data)
            return result
        } catch {
            if let raw = String(data: data, encoding: .utf8) {
                print("⚠️ Raw response:\n\(raw)")
            }
            throw error
        }
        throw NSError(domain: "HTTP Error", code: 342)
    }
    
    func fetchDailyMeal(userProfile: UserProfile, analyzeResult: AnalyzeResult) async throws -> DailyMealResponse {
        guard let url = URL(string: "http://127.0.0.1:8000/daily-meal") else {
            throw URLError(.badURL)
        }
        
        // ✅ Build request body manually (with correct key names)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        

        // Encode sub-objects separately
        let userProfileData = try encoder.encode(userProfile.forDailyMeal)
        let analyzeData = try encoder.encode(analyzeResult)
        
        // Decode them back into [String: Any]
        let userProfileDict = try JSONSerialization.jsonObject(with: userProfileData) as! [String: Any]
        let analyzeString = String(data: analyzeData, encoding: .utf8) ?? ""
        
        // Combine both
        let body: [String: Any] = [
            "user_profile": userProfileDict,
            "analyze_result": analyzeString
        ]
        
        // Convert final body to JSON
        let jsonData = try JSONSerialization.data(withJSONObject: body)
        
        // ✅ Create request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        // ✅ Perform request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        // ✅ Decode server response
        let decoded = try JSONDecoder().decode(DailyMealResponse.self, from: data)
        return decoded
    }
    
    func chatWithUser(userID: String, userInput: String) async throws -> ChatMessage {
        guard let url = URL(string: "http://127.0.0.1:8000/chat/\(userID)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["user_input": userInput]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(ChatMessage.self, from: data)
    }
}
