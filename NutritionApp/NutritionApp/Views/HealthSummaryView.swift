//
//  HealthSummaryView.swift
//  NutritionApp
//
//  Created by hung on 6/11/25.
//

import SwiftUI

struct HealthSummaryView: View {
    
    @EnvironmentObject var shared: SharedData
    let isInTabBar: Bool

    @State private var isEditing = false

    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                // MARK: - SECTION 1: USER INFO
                SectionView(title: "Thông tin bạn đã cung cấp") {
                    VStack(spacing: 12) {
                        infoRow(label: "Tên", value: shared.userProfile.name, systemImage: "person.fill")
                        infoRow(label: "Cân nặng", value: shared.userProfile.weight, systemImage: "scalemass")
                        infoRow(label: "Chiều cao", value: shared.userProfile.height, systemImage: "ruler.fill")
                    }
                }
                
                // MARK: - SECTION 2: BMI
                SectionView(title: "Chỉ số BMI") {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Giá trị: \(shared.analyzeResult.bmi.value)")
                                .fontWeight(.medium)
                            Spacer()
                            Text(shared.analyzeResult.bmi.status.capitalized)
                                .fontWeight(.bold)
                                .foregroundColor(statusColor(shared.analyzeResult.bmi.status))
                        }
                        Text(shared.analyzeResult.bmi.comment)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        // Mini bar visualize BMI range
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(Color(.systemGray4))
                                    .frame(height: 8)
                                    .cornerRadius(4)
                                Rectangle()
                                    .fill(statusColor(shared.analyzeResult.bmi.status))
                                    .frame(width: geo.size.width * bmiRatio(), height: 8)
                                    .cornerRadius(4)
                            }
                        }
                        .frame(height: 8)
                    }
                }
                
                // MARK: - SECTION 3: BLOOD TEST
                //                if let bloodTest = shared.userProfile.bloodTest {
                //                    SectionView(title: "Xét nghiệm máu", icon: "drop.fill", iconColor: .red) {
                //                        VStack(spacing: 12) {
                //                            ForEach(bloodTest.indicators) { indicator in
                //                                indicatorCard(indicator: indicator)
                //                            }
                //                        }
                //                    }
                //                }
                
                // MARK: - SECTION 4: URINE TEST
                SectionView(title: "Kết quả xét nghiệm", icon: "drop.triangle.fill", iconColor: .yellow) {
                    VStack(spacing: 12) {
                        ForEach(shared.analyzeResult.indicators) { indicator in
                            indicatorCard(indicator: indicator)
                        }
                    }
                }
                
                // MARK: - SECTION 5: GENERAL EVALUATION
                if !shared.analyzeResult.general_evaluation.isEmpty {
                    SectionView(title: "Đánh giá tổng quan") {
                        Text(shared.analyzeResult.general_evaluation)
                            .foregroundColor(.gray)
                            .font(.body)
                    }
                }
                
                // MARK: - SECTION 6: DETAILS
                if !shared.analyzeResult.details.isEmpty {
                    SectionView(title: "Chi tiết") {
                        Text(shared.analyzeResult.details)
                            .foregroundColor(.gray)
                            .font(.body)
                    }
                }
                
                // MARK: - SECTION 7: POTENTIAL RISKS
                if !shared.analyzeResult.potential_risks.isEmpty {
                    SectionView(title: "Rủi ro tiềm ẩn", icon: "exclamationmark.triangle.fill", iconColor: .orange) {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(shared.analyzeResult.potential_risks, id: \.self) { risk in
                                Label(risk, systemImage: "xmark.octagon.fill")
                                    .foregroundColor(.red)
                                    .font(.body)
                            }
                        }
                    }
                }
                
                // MARK: - SECTION 8: ADVICE
                if !shared.analyzeResult.advice.isEmpty {
                    SectionView(title: "Lời khuyên", icon: "lightbulb.fill", iconColor: .green) {
                        Text(shared.analyzeResult.advice)
                            .foregroundColor(.gray)
                            .font(.body)
                    }
                }
                if !isInTabBar {
                    // MARK: - ACTION BUTTON
                    Button(action: {
                        withAnimation(.easeInOut) {
                            shared.didLaunchApp = true
                        }
                    }) {
                        Text("Tạo thực đơn 1 ngày")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .shadow(color: .green.opacity(0.3), radius: 5, x: 0, y: 3)
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 40)
                        .padding(.top)
                    
                }
            }
        }
        .navigationTitle("Kết quả phân tích")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if shared.didLaunchApp {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isEditing = true
                    } label: {
                        Image(systemName: "pencil")
                            .imageScale(.large)
                    }
                }
            }
            
        }
        .fullScreenCover(isPresented: $isEditing) {
            NavigationStack {
                ProfileEditView()
            }
        }
    }
    
    // MARK: - REUSABLE COMPONENTS
    
    private func indicatorCard(indicator: AnalyzeResult.Indicator) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(indicator.name)
                    .fontWeight(.medium)
                Spacer()
                Text("\(indicator.value)\(indicator.unit ?? "")")
                    .foregroundColor(.gray)
            }
            
            HStack {
                Text("Bình thường: \(indicator.normal_range)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text(indicator.status.capitalized)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(statusColor(indicator.status))
            }
            
            // Mini bar visualize indicator
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .frame(height: 8)
                        .cornerRadius(4)
                    Rectangle()
                        .fill(statusColor(indicator.status))
                        .frame(width: geo.size.width * progressRatio(indicator: indicator), height: 8)
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
            
            if !indicator.comment.isEmpty {
                Text(indicator.comment)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, 2)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private func infoRow(label: String, value: String, systemImage: String? = nil) -> some View {
        HStack {
            if let systemImage {
                Image(systemName: systemImage)
                    .foregroundColor(.blue)
            }
            Text(label + ":")
                .fontWeight(.medium)
            Spacer()
            Text(value)
                .foregroundColor(.gray)
        }
        .font(.body)
    }
    
    private func statusColor(_ status: String) -> Color {
        switch status.lowercased() {
        case "low": return .orange
        case "high": return .red
        default: return .green
        }
    }
    
    private func progressRatio(indicator: AnalyzeResult.Indicator) -> CGFloat {
        switch indicator.status.lowercased() {
        case "low": return 0.3
        case "high": return 0.8
        default: return 0.5
        }
    }
    
    private func bmiRatio() -> CGFloat {
        switch shared.analyzeResult.bmi.status.lowercased() {
        case "underweight": return 0.3
        case "overweight": return 0.7
        case "obese": return 0.9
        default: return 0.5
        }
    }
}

// MARK: - SECTION WRAPPER
struct SectionView<Content: View>: View {
    var title: String
    var icon: String?
    var iconColor: Color = .blue
    @ViewBuilder var content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                if let icon {
                    Image(systemName: icon)
                        .foregroundColor(iconColor)
                }
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            content
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .padding(.horizontal)
    }
}
