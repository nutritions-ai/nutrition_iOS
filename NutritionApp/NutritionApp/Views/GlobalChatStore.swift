//
//  GlobalChatStore.swift
//  NutritionApp
//
//  Created by Chỉnh Trần on 8/11/25.
//

import Foundation
import SwiftUI
import Combine

struct QuestionHistory: Identifiable, Codable, Hashable {
    let id: UUID
    let text: String
    let date: Date
}

final class GlobalChatStore: ObservableObject {
    static let shared = GlobalChatStore()
    
    @Published var questionHistory: [QuestionHistory] = [] {
        didSet {
            saveToUserDefaults()
        }
    }
    
    private let key = "questionHistory"
    
    private init() {
        loadFromUserDefaults()
    }
    
    private func saveToUserDefaults() {
        if let data = try? JSONEncoder().encode(questionHistory) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    private func loadFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([QuestionHistory].self, from: data) {
            questionHistory = decoded
        }
    }
    
    func addQuestion(message: ChatMessage) {
        let item = QuestionHistory(id: message.id, text: message.content, date: Date())
        questionHistory.append(item)
    }
    
    func clearHistory() {
        questionHistory.removeAll()
    }
}
