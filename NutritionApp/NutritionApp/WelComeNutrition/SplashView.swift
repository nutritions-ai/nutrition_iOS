//
//  SplashView.swift
//  NutritionApp
//
//  Created by Chỉnh Trần on 25/10/25.
//

import SwiftUI

struct SplashView: View {
    @AppStorage("hasLaunchedBefore") var hasLaunchedBefore: Bool = false
    @State private var showNext = false
    @State private var scale: CGFloat = 0.9
    @State private var opacity: Double = 0.8
    @State private var showSubtitle = false
    
    var body: some View {
        ZStack {
            Color(red: 0.56, green: 0.83, blue: 0.35)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                Text("nutrition")
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeOut(duration: 1.2)) {
                            self.scale = 1.0
                            self.opacity = 1.0
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                            withAnimation(.easeIn(duration: 1.0)) {
                                self.showSubtitle = true
                            }
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                self.showNext = true
                            }
                            self.hasLaunchedBefore = true
                        }
                    }
                
                if showSubtitle {
                    Text("Ứng dụng dinh dưỡng giúp bạn hiểu rõ hơn\nvề sức khoẻ và thực phẩm hằng ngày.")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                        .padding(.horizontal, 24)
                }
            }
        }
        .fullScreenCover(isPresented: $showNext) {
            NavigationStack {
                ChatView()
            }
        }
    }
}
