//
//  AnalyzeResultView.swift
//  NutritionApp
//
//  Created by hung on 5/11/25.
//

import SwiftUI

struct AnalyzingView: View {
    @State private var isAnalyzing = true
    @State private var showHealthSummary = false
    @State private var analyzeResult: String = ""
    
    @EnvironmentObject var shared: SharedData
    
    @Environment(\.dismiss) var dismiss
    
    let onComplete: () -> Void?



    var body: some View {
            ZStack {
                if showHealthSummary {
                    HealthSummaryView(isInTabBar: false)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                        .environmentObject(shared)
                } else {
                    VStack(spacing: 30) {
                        if isAnalyzing {
                            VStack(spacing: 20) {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .green))
                                    .scaleEffect(2.0)
                                
                                Text("Đang phân tích dữ liệu sức khoẻ...")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                            }
                            .transition(.opacity.combined(with: .scale))
                        } else {
                            VStack(spacing: 20) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(.green)
                                
                                Text("Phân tích hoàn tất")
                                    .font(.headline)
                            }
                            .transition(.opacity)
                        }                        
                    }
                    .padding()
                }
            }
            .onAppear {
                Task {
                    analyze()
                }
            }
            .animation(.easeInOut, value: showHealthSummary)
        }
    
    private func analyze() {
        Task {
                // Start analyzing animation
                isAnalyzing = true
                showHealthSummary = false
                analyzeResult = ""
                
                do {
                    // Call API (await result)
                    let result = try await APIClient.shared.sendHealthAnalysis(profile: shared.userProfile)

                    // Stage 1: show "complete" after short delay
                    try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
                    withAnimation {
                        isAnalyzing = false
                        analyzeResult = "Phân tích hoàn tất"
                    }
                    
                    // Stage 2: show health summary after another delay
                    try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
                    withAnimation {
                        analyzeResult = "result"
                        shared.analyzeResult = result
                        if shared.didLaunchApp {
                            onComplete()
                            dismiss()
                        } else {
                            showHealthSummary = true
                        }
                    }
                } catch {
                    // Handle API error
                    withAnimation {
                        isAnalyzing = false
                        analyzeResult = "❌ Lỗi phân tích: \(error.localizedDescription)"
                        showHealthSummary = true
                    }
                }
            }
    }
    
    private func simulateServerRequest() {
        // Fake async "server" request after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            withAnimation {
                isAnalyzing = false
                analyzeResult = "Chuẩn bị hiển thị kết quả chi tiết..."
            }
            
            // Show health summary after another short delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showHealthSummary = true
                }
            }
        }
    }
}
