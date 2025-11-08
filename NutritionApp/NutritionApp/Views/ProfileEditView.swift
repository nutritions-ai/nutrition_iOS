//
//  ProfileView.swift
//  NutritionApp
//
//  Created by Chỉnh Trần on 3/11/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct ProfileEditView: View {

    @State private var name: String = ""
    @State private var age: String = ""
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var bloodPressure: String = ""
    @State private var healthStatus: String = "Bình thường"
    @State private var bloodTestImage: UIImage?
    @State private var urineTestImage: UIImage?
    
    let healthOptions = ["Bình thường", "Tốt", "Trung bình", "Yếu"]
    
    @State private var navigateToHome = false
    @State private var navigateToAnalyze = false
    @State private var isShowingPDFPicker = false
    
    @EnvironmentObject var shared: SharedData
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Form {
            // MARK: - Personal Info
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
            
            // MARK: - Blood Test
            Section(header: Text("Kết quả xét nghiệm máu")) {
                ImagePickerView(selectedImage: $bloodTestImage)
            }
            
            // MARK: - Urine Test
            Section(header: Text("Kết quả xét nghiệm nước tiểu")) {
                ImagePickerView(selectedImage: $urineTestImage)
            }
            
            // MARK: - Save Button
            Section {
                Button(action: saveProfile) {
                    Text("Lưu thông tin")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                }
            }
        }
        .navigationTitle("Hồ sơ cá nhân")
        .navigationDestination(isPresented: $navigateToAnalyze) {
            AnalyzingView(onComplete: {
                if shared.didLaunchApp {
                    dismiss()
                }
            })
            .environmentObject(shared)
        }
    }
    
    private func saveProfile() {
        print("Đã lưu hồ sơ: \(name)")
        let userProfile = UserProfile(
            name: name,
            age: age,
            weight: weight,
            height: height,
            bloodTest: bloodTestImage,
            urineTest: urineTestImage
        )
        shared.userProfile = userProfile
        
        withAnimation(.easeInOut) {
            navigateToAnalyze = true
        }
    }
}

#Preview {
    ProfileEditView()
}
