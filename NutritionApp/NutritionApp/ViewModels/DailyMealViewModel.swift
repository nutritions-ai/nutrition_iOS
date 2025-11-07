//
//  DailyMealViewModel.swift
//  NutritionApp
//
//  Created by hung on 6/11/25.
//

import SwiftUI
import Combine

final class DailyMealViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var isLoading = false
    
    @Published var shared = SharedData.shared


    func fetchDailyMeals() async {
        guard !isLoading else { return } // prevent double call
        isLoading = true
        defer { isLoading = false }
        do {
            let result = try await APIClient.shared.fetchDailyMeal(
                userProfile: shared.userProfile,
                analyzeResult: shared.analyzeResult
            )
            await MainActor.run {
                self.meals = result.meals
            }
        } catch {
            print("Error fetching meals: \(error)")
        }
    }
}
