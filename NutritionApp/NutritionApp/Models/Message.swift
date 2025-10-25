//
//  Message.swift
//  NutritionApp
//
//  Created by 49 on 18/10/25.
//

import Foundation

struct ChatMessage: Identifiable, Codable {
    var id = UUID()
    let role: String     // "user" or "assistant"
    let content: String
    
    var isFromUser: Bool { role != "assistant" }
}
