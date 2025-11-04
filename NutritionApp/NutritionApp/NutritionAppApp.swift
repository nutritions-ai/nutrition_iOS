//
//  NutritionAppApp.swift
//  NutritionApp
//
//  Created by hung on 18/10/25.
//

import SwiftUI

@main
struct NutritionAppApp: App {
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore: Bool = false
    @AppStorage("userName") private var userName: String = ""
    
    var body: some Scene {
        WindowGroup {
            if !hasLaunchedBefore {
                // SplashView cần NavigationStack để điều hướng tới ProfileView
                NavigationStack {
                    SplashView()
                }
            } else {
                // Khi đã vào app chính, KHÔNG bọc TabBarView bằng NavigationStack nữa
                TabBarView(userName: userName)
            }
        }
    }
}
