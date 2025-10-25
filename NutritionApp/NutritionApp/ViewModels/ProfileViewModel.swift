//
//  ProfileViewModel.swift
//  NutritionApp
//
//  Created by 49 on 25/10/25.
//

import Foundation

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var profile: Profile
    
    private let defaultsKey = "UserProfile"
    
    init() {
        if let savedData = UserDefaults.standard.data(forKey: defaultsKey),
           let decoded = try? JSONDecoder().decode(Profile.self, from: savedData) {
            // Có dữ liệu đã lưu
            profile = decoded
        } else {
            // Dữ liệu mặc định
            profile = Profile(height: 0, weight: 0, gender: "Nam", age: 0)
        }
    }
    
    func saveProfile() {
        if let encoded = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(encoded, forKey: defaultsKey)
        }
    }
}
