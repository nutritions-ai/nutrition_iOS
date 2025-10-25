//
//  Profile.swift
//  NutritionApp
//
//  Created by 49 on 25/10/25.
//

import Foundation

struct Profile: Codable {
    var height: Double
    var weight: Double
    var gender: String
    var age: Int
    
    init(height: Double, weight: Double, gender: String, age: Int) {
        self.height = height
        self.weight = weight
        self.gender = gender
        self.age = age
    }
}
