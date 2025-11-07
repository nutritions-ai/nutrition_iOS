
//  TabBarView.swift
//  NutritionApp
//
//  Created by Chỉnh Trần on 3/11/25.
//

import SwiftUI

struct TabBarView: View {
    @EnvironmentObject var shared: SharedData
    @State private var path: [String] = []

    var body: some View {
        TabView {
            NavigationStack {
                DailyMealView()
                    .environmentObject(shared)

            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            NavigationStack {
                ChatView()
            }
            .tabItem {
                Label("Chat", systemImage: "bubble.left.and.bubble.right.fill")
            }
            NavigationStack {
                HistoryView()
            }
            .tabItem {
                Label("Lịch sử", systemImage: "clock.fill")
            }
            NavigationStack {
                
                HealthSummaryView(isInTabBar: true)
                    .environmentObject(shared)

            }
            .tabItem {
                Label("Hồ sơ", systemImage: "person.crop.circle.fill")
            }
        }
        .tint(.gray)
        .navigationBarBackButtonHidden(true)
    }
}
