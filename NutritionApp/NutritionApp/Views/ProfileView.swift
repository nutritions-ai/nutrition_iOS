//
//  ProfileView.swift
//  NutritionApp
//
//  Created by Chỉnh Trần on 3/11/25.
//

import SwiftUI

struct ProfileView: View {
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore: Bool = false

    @State private var name: String = ""
    @State private var age: String = ""
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var bloodPressure: String = ""
    @State private var healthStatus: String = "Bình thường"
    
    let healthOptions = ["Bình thường", "Tốt", "Trung bình", "Yếu"]
    
    @State private var navigateToHome = false

    var body: some View {
        NavigationStack {
            Form {
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
                
                Section(header: Text("Sức khoẻ (tuỳ chọn)")) {
                    TextField("Huyết áp (vd: 120/80)", text: $bloodPressure)
                        .keyboardType(.numbersAndPunctuation)
                    
                    Picker("Tình trạng sức khoẻ", selection: $healthStatus) {
                        ForEach(healthOptions, id: \.self) { status in
                            Text(status)
                        }
                    }
                }
                
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
            .navigationDestination(isPresented: $navigateToHome) {
                TabBarView(userName: name)
                    .navigationBarBackButtonHidden(true)
                    .onAppear {
                        hasLaunchedBefore = true
                    }
            }
        }
    }
    
    
    private func saveProfile() {
        print("Đã lưu hồ sơ: \(name)")
        
        withAnimation(.easeInOut) {
            navigateToHome = true
        }
    }
//    private func saveProfile() {
//        print("""
//        --- Hồ sơ người dùng ---
//        Họ tên: \(name)
//        Tuổi: \(age)
//        Chiều cao: \(height)
//        Cân nặng: \(weight)
//        Huyết áp: \(bloodPressure)
//        Sức khoẻ: \(healthStatus)
//        """)
//    }
}

#Preview {
    ProfileView()
}
