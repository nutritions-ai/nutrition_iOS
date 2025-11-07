//
//  ProfileView.swift
//  NutritionApp
//
//  Created by hung on 6/11/25.
//


import SwiftUI

struct ProfileView: View {
    @State private var name = ""
    @State private var age = ""
    @State private var height = ""
    @State private var weight = ""
    
    @State private var bloodTestImage: UIImage?
    @State private var urineTestImage: UIImage?
    
    @State private var isAnalyzing = false
    @State private var analyzeResult: String?
    
    
    @EnvironmentObject var shared: SharedData

    
    var body: some View {
            Form {
                // MARK: - Thông tin cá nhân
                Section(header: Text("Thông tin cá nhân")) {
                    TextField("Họ và tên", text: $name)
                        .textInputAutocapitalization(.words)
                    
                    TextField("Tuổi", text: $age)
                        .keyboardType(.numberPad)
                    
                    TextField("Chiều cao (cm)", text: $height)
                        .keyboardType(.decimalPad)
                    
                    TextField("Cân nặng (kg)", text: $weight)
                        .keyboardType(.decimalPad)
                }
                
                // MARK: - Ảnh xét nghiệm
                Section(header: Text("Kết quả xét nghiệm máu")) {
                    ImagePickerView(selectedImage: $bloodTestImage)
                }
                
                Section(header: Text("Kết quả xét nghiệm nước tiểu")) {
                    ImagePickerView(selectedImage: $urineTestImage)
                }
                
                // MARK: - Lưu & Phân tích
                Section {
                    if isAnalyzing {
                        HStack {
                            ProgressView()
                            Text("Đang phân tích...")
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        Button(action: saveAndAnalyzeProfile) {
                            Text("Lưu & Phân tích")
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(12)
                        }
                    }
                }
                
                // MARK: - Kết quả phân tích
                if let result = analyzeResult {
                    Section(header: Text("Kết quả phân tích")) {
                        Text(result)
                            .font(.body)
                            .foregroundColor(.primary)
                            .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Hồ sơ cá nhân")
            .onAppear {
                loadProfile()
            }
        }
    
    // MARK: - Actions
    
    func loadProfile() {
        let profile = SharedData.shared.userProfile
        name = profile.name
        age = profile.age
        height = profile.height
        weight = profile.weight
    }
    
    func saveAndAnalyzeProfile() {
        Task {
            isAnalyzing = true
            defer { isAnalyzing = false }
            
            // Lưu hồ sơ vào SharedData
            let profile = UserProfile(
                name: name,
                age: age,
                weight: weight,
                height: height,
                bloodTest: nil,
                urineTest: nil
            )
            SharedData.shared.userProfile = profile
            
            do {
                let result = try await APIClient.shared.sendHealthAnalysis(profile: profile)
                analyzeResult = "result"
//                SharedData.shared.analyzeResult = "result"
            } catch {
                analyzeResult = "Lỗi khi phân tích: \(error.localizedDescription)"
            }
        }
    }
}
