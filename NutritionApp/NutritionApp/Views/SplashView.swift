//
//  SplashView.swift
//  NutritionApp
//
//  Created by Chỉnh Trần on 30/10/25.
//

import SwiftUI

struct SplashView: View {
    @State private var scale: CGFloat = 0.9
    @State private var opacity: Double = 0.8
    @State private var showSubtitle = false
    
    @State private var navigateToProfile = false
    @EnvironmentObject var shared: SharedData

    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea()
            VStack(spacing: 0) {
                Spacer()
                VStack(spacing: 16) {
                    Image("iconNutri")
                        .resizable()
                        .frame(width: 200,height: 200)
                        .padding([.horizontal,.vertical])
                    
                    Text("nutrition")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundColor(.green)
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
                        }
                    
                    if showSubtitle {
                        Text("Ứng dụng dinh dưỡng giúp bạn hiểu rõ hơn\nvề sức khoẻ và thực phẩm hằng ngày.")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.green.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                            .padding(.horizontal, 24)
                    }
                }
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                
                Spacer()
                
                if showSubtitle {
                    Button {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            navigateToProfile = true
                        }
                    } label: {
                        Text("Get started")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.green)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                            .padding(.horizontal, 24)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, 20)
                } else {
                    Color.clear
                        .frame(height: 20)
                }
            }
        }
        .navigationDestination(isPresented: $navigateToProfile) {
            ProfileEditView()
                .navigationBarBackButtonHidden(true)
                .environmentObject(shared)
        }
    }
}
