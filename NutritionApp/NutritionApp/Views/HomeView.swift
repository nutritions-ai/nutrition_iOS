//
//  HomeView.swift
//  NutritionApp
//
//  Created by Chỉnh Trần on 3/11/25.
//

import SwiftUI

struct HomeView: View {
    var userName: String
    var messageSent: String = "0"
    var messageReceive: String = "0"
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical,showsIndicators: false) {
                VStack(alignment: .leading,spacing: 24) {
                    // MARK: - Header
                    HStack(alignment:.center,spacing: 16) {
                        Image("User")
                            .resizable()
                            .frame(width: 60,height: 60)
                        
                        VStack {
                            Text("Chào mừng \(userName) 👋")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            
                            Text("Chào bạn tới Nutrition App")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                    
                    // MARK: Reports
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Monthly Reports")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        Text("Báo cáo hàng tháng về hoạt động\ncủa bạn")
                            .lineLimit(2)
                            .padding(.horizontal)
                            .font(.headline)
                            .fontWeight(.bold)
                           
                        // MARK: StatCard
                        HStack {
                            StatCard(title: "Message đã gửi", value: messageSent)
                            StatCard(title: "Message đã nhận ", value: messageReceive)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    HomeView(userName: "ac")
}
