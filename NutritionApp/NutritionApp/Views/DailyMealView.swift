//
//  DailyMealView.swift
//  NutritionApp
//
//  Created by hung on 5/11/25.
//
import SwiftUI

struct DailyMealView: View {
    
    @StateObject private var viewModel = DailyMealViewModel()

    @EnvironmentObject var shared: SharedData

    var body: some View {
        VStack(spacing: 0) {
            
            if viewModel.isLoading {
                // MARK: - Loading Indicator
                VStack(spacing: 16) {
                    ProgressView("Đang tạo thực đơn...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .green))
                        .font(.headline)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemGroupedBackground))
            }
            else {
                // MARK: - Meal List
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(viewModel.meals) { meal in
                            VStack(alignment: .leading, spacing: 16) {
                                Text(meal.name)
                                    .font(.title3.bold())
                                    .foregroundColor(.green)
                                
                                VStack(spacing: 10) {
                                    ForEach(meal.dishes) { dish in
                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(dish.name)
                                                    .font(.body)
                                                    .fontWeight(.medium)
                                                    .foregroundColor(.primary)
                                                
                                                Text(dish.portion)
                                                    .font(.subheadline)
                                                    .foregroundColor(.gray)
                                            }
                                            Spacer()
                                        }
                                        .padding()
                                        .background(Color(.systemGray6))
                                        .cornerRadius(14)
                                        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                                    }
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(color: .green.opacity(0.1), radius: 6, x: 0, y: 3)
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 30)
                }
                .background(Color(.systemGroupedBackground))
            }
        }
        .navigationTitle("Thực đơn 1 ngày")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if viewModel.meals.isEmpty {
                await viewModel.fetchDailyMeals()
            }
        }
        
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task {
                        await viewModel.fetchDailyMeals()
                    }
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .imageScale(.large)
                }
            }
        }
    }
}
