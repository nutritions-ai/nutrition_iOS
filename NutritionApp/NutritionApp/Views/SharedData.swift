//
//  SharedData.swift
//  NutritionApp
//
//  Created by hung on 6/11/25.
//

import Foundation
import SwiftUI
import Combine

final class SharedData: ObservableObject {
    static let shared = SharedData()
    
    // MARK: - UserProfile stored individually with AppStorage
    @AppStorage("name") var name: String = ""
    @AppStorage("age") var age: String = ""
    @AppStorage("weight") var weight: String = ""
    @AppStorage("height") var height: String = ""
    @Published var currentUserProfile = UserProfile(
        name: "",
        age: "",
        weight: "",
        height: "",
        bloodTest: nil,
        urineTest: nil
    )
    
//    @AppStorage("didLaunchApp") var didLaunchApp: Bool = false
    
    
    @Published var selectedTab: Int = 0               // tab hiện tại
    @Published var scrollToMessageID: UUID? = nil     // message cần scroll trong ChatView

    // Computed property for convenience
    var userProfile: UserProfile {
        get {
            UserProfile(
                name: name,
                age: age,
                weight: weight,
                height: height,
                bloodTest: currentUserProfile.bloodTest,
                urineTest: nil
            )
        }
        set {
            name = newValue.name
            age = newValue.age
            weight = newValue.weight
            height = newValue.height
            // bloodTest and urineTest are not persisted in this setup
        }
    }
    
    // MARK: - Other persistent values
    @AppStorage("didLaunchApp") var didLaunchApp: Bool = false
    
    @Published var analyzeResult: AnalyzeResult {
        didSet { saveAnalyzeResult() }
    }
    
    private init() {
        self.analyzeResult = Self.loadAnalyzeResult()
    }
}

// MARK: - Persistence for AnalyzeResult
extension SharedData {
    private func saveAnalyzeResult() {
        if let data = try? JSONEncoder().encode(analyzeResult) {
            UserDefaults.standard.set(data, forKey: "analyzeResult")
        }
    }
    
    private static func loadAnalyzeResult() -> AnalyzeResult {
        guard let data = UserDefaults.standard.data(forKey: "analyzeResult"),
              let result = try? JSONDecoder().decode(AnalyzeResult.self, from: data)
        else {
            return .default
        }
        return result
    }
}
