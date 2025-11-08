//
//  FoodItem.swift
//  NutritionApp
//
//  Created by hung on 8/11/25.
//

import SwiftUI

struct FoodItem: Codable, Identifiable {
    let id = UUID()
    let name: String
    let estimatedWeight: Double
    let calories: Double
    let boundingBox: [Int]

    enum CodingKeys: String, CodingKey {
        case name
        case estimatedWeight = "estimated_weight"
        case calories
        case boundingBox = "bounding_box"
    }
}

struct AnalyzeResponse: Codable {
    let result: [FoodItem]
}
