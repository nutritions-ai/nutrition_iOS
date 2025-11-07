//
//  UserProfile.swift
//  NutritionApp
//
//  Created by hung on 5/11/25.
//

import SwiftUI
import Foundation

struct UserProfile {
    let id: String = UUID().uuidString
    let name: String
    let age: String
    let weight: String
    let height: String
    let bloodTest: UIImage?
    let urineTest: UIImage?

}

extension UserProfile {
    var forDailyMeal: UserProfileForDailyMeal {
        UserProfileForDailyMeal(
            name: name,
            age: age,
            weight: weight,
            height: height
        )
    }
}

struct UserProfileForDailyMeal: Codable {
    let name: String
    let age: String
    let weight: String
    let height: String
}
