//
//  Meal.swift
//  NutritionApp
//
//  Created by hung on 5/11/25.
//

import Foundation

struct Meal: Identifiable, Codable {
    var id = UUID()
    let name: String
    let dishes: [Dish]
    
    private enum CodingKeys: String, CodingKey {
        case name, dishes
    }
}

struct Dish: Identifiable, Codable {
    var id = UUID()
    let name: String
    let portion: String
    
    private enum CodingKeys: String, CodingKey {
        case name, portion
    }
}

struct DailyMealResponse: Codable {
    let meals: [Meal]
}
