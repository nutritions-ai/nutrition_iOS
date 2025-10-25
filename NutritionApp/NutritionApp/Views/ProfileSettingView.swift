//
//  SettingProfiles.swift
//  NutritionApp
//
//  Created by 49 on 25/10/25.
//

import SwiftUI

struct ProfileSettingView: View {
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var gender: String = "Nam"
    @State private var age: String = ""
    @State private var showAlert = false

    let genders = ["Nam", "Nữ", "Khác"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Thông tin cá nhân")) {
                    TextField("Chiều cao (cm)", text: $height)
                        .keyboardType(.numberPad)
                    
                    TextField("Cân nặng (kg)", text: $weight)
                        .keyboardType(.numberPad)
                    
                    Picker("Giới tính", selection: $gender) {
                        ForEach(genders, id: \.self) { gender in
                            Text(gender)
                        }
                    }
                    
                    TextField("Tuổi", text: $age)
                        .keyboardType(.numberPad)
                }
                
                Section {
                    Button(action: {
                        showAlert = true
                    }) {
                        HStack {
                            Spacer()
                            Text("Lưu hồ sơ")
                                .fontWeight(.bold)
                            Spacer()
                        }
                    }
                    .alert("Đã lưu thông tin!", isPresented: $showAlert) {
                        Button("OK", role: .cancel) {}
                    }
                }
            }
            .navigationTitle("Cài đặt hồ sơ")
        }
    }
}
