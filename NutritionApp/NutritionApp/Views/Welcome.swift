//
//  Welcome.swift
//  NutritionApp
//
//  Created by 49 on 25/10/25.
//

import SwiftUI

struct Welcome: View {
    @State private var navigateToNext = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.green.opacity(0.4), Color.blue.opacity(0.3)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Spacer()
                    
                    // App logo or icon
                    Image(systemName: "leaf.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.green)
                        .shadow(radius: 8)
                    
                    // Title
                    Text("Nutrition")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.primary)
                    
                    // Subtitle
                    Text("""
                    Trợ lý sức khoẻ cá nhân của bạn.
                    Sử dụng AI để tạo thực đơn dinh dưỡng,
                    theo dõi sức khỏe và gợi ý ăn uống phù hợp mỗi ngày.
                    """)
                        .font(.system(size: 18))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Spacer()
                    
                    // Modern navigation destination
                    Button(action: {
                        navigateToNext = true
                    }) {
                        Text("Let’s Start")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                            .padding(.horizontal, 40)
                    }
                    .navigationDestination(isPresented: $navigateToNext) {
                        ChatView()
                    }
                    
                    Spacer().frame(height: 60)
                }
            }
        }
    }
}

#Preview {
    Welcome()
}
