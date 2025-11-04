
//  TabBarView.swift
//  NutritionApp
//
//  Created by Chỉnh Trần on 3/11/25.
//

import SwiftUI

struct TabBarView: View {
    var userName: String

    var body: some View {
        TabView {
            NavigationStack {
                HomeView(userName: userName)
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }

            NavigationStack {
                ChatViewNew()
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
        }
        .tint(.gray)
    }
}

#Preview {
    TabBarView(userName: "a")
}
