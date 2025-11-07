//
//  Message.swift
//  NutritionApp
//
//  Created by 49 on 18/10/25.
//

import Foundation

struct ChatMessage: Identifiable, Codable {
    var id = UUID()  // generated locally, not decoded from JSON
    let role: String
    let content: String
    
    var isFromUser: Bool { role != "assistant" }

    enum CodingKeys: String, CodingKey {
        case role, content
    }
}
