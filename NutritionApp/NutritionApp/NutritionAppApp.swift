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
    
    var body: some Scene {
        WindowGroup {
            if hasLaunchedBefore {
                NavigationStack {
                    ChatView()
                }
            } else {
                SplashView()
            }
        }
    }
}
