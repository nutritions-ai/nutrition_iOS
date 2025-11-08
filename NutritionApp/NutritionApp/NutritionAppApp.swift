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
    
    @StateObject private var shared = SharedData.shared


    init() {
        GlobalChatStore.shared.clearHistory()
    }
    
    var body: some Scene {
        WindowGroup {
            if !shared.didLaunchApp {
                // SplashView cần NavigationStack để điều hướng tới ProfileView
                NavigationStack {
                    SplashView()
                        .environmentObject(shared)
                }
            } else {
                // Khi đã vào app chính, KHÔNG bọc TabBarView bằng NavigationStack nữa
                TabBarView()
                    .environmentObject(shared)
            }
        }
    }
//    
//    var body : some Scene {
//        WindowGroup {
//            NavigationStack {
//                ChatView()
//                    .environmentObject(shared)
//            }
//        }
//    }
}
