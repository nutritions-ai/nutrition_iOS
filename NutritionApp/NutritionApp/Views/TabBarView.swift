
//  TabBarView.swift
//  NutritionApp
//
//  Created by Chỉnh Trần on 3/11/25.
//

import SwiftUI

struct TabBarView: View {
    @EnvironmentObject var shared: SharedData
    @State private var selectedTab: Int = 0 // 0: Home, 1: Chat, 2: History, 3: Profile

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                DailyMealView()
                    .environmentObject(shared)
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .tag(0)

            NavigationStack {
                ChatView()
                    .environmentObject(shared)
            }
            .tabItem {
                Label("Chat", systemImage: "bubble.left.and.bubble.right.fill")
            }
            .tag(1)

            NavigationStack {
                HistoryView { selectedMessageID in
                    // 1️⃣ Lưu ID message cần scroll
                    shared.scrollToMessageID = selectedMessageID
                    // 2️⃣ Chuyển tab sang Chat
                    selectedTab = 1
                }
            }
            .tabItem {
                Label("Lịch sử", systemImage: "clock.fill")
            }
            .tag(2)
            
            NavigationStack {
                HealthSummaryView(isInTabBar: true)
                    .environmentObject(shared)
            }
            .tabItem {
                Label("Hồ sơ", systemImage: "person.crop.circle.fill")
            }
            .tag(3)
        }
        .tint(.gray)
        .navigationBarBackButtonHidden(true)
    }
}
