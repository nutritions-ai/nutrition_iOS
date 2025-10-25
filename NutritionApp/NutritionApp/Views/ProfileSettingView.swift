//
//  SettingProfiles.swift
//  NutritionApp
//
//  Created by 49 on 25/10/25.
//

import SwiftUI

struct ProfileSettingView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showAlert = false
    @State private var showChat = false

    let genders = ["Nam", "Nữ", "Khác"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Thông tin cá nhân")) {
                    TextField("Chiều cao (cm)", value: $viewModel.profile.height, format: .number)
                        .keyboardType(.decimalPad)
                    
                    TextField("Cân nặng (kg)", value: $viewModel.profile.weight, format: .number)
                        .keyboardType(.decimalPad)
                    
                    Picker("Giới tính", selection: $viewModel.profile.gender) {
                        ForEach(genders, id: \.self) { gender in
                            Text(gender)
                        }
                    }
                    
                    TextField("Tuổi", value: $viewModel.profile.age, format: .number)
                        .keyboardType(.numberPad)
                }
                
                Section {
                    Button(action: {
                        viewModel.saveProfile()
                        showAlert = true
                    }) {
                        HStack {
                            Spacer()
                            Text("Lưu hồ sơ")
                                .fontWeight(.bold)
                            Spacer()
                        }
                    }
                    .alert("Đã lưu thông tin thành công!", isPresented: $showAlert) {
                        Button("OK", role: .cancel) {
                            showChat = true
                        }
                    }
                    .sheet(isPresented: $showChat) {
                        ChatView() // View mà bạn muốn present
                    }
                }
            }
            .navigationTitle("Cài đặt hồ sơ")
        }
    }
}
