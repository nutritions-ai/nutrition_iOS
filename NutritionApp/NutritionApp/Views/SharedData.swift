//
//  SharedData.swift
//  NutritionApp
//
//  Created by hung on 6/11/25.
//

import Foundation
import SwiftUI
import Combine

class SharedData: ObservableObject {
    static let shared = SharedData()
    
    @Published var userProfile = UserProfile(
        name: "",
        age: "",
        weight: "",
        height: "",
        bloodTest: nil,
        urineTest: nil
    )
    
    @Published var analyzeResult: AnalyzeResult = .default
    
//    @AppStorage("didLaunchApp") var didLaunchApp: Bool = false
    
    @Published var didLaunchApp: Bool = false


    private init() {} // prevent external instantiation
}
