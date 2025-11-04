//
//  HistoryView.swift
//  NutritionApp
//
//  Created by Chỉnh Trần on 3/11/25.
//

import SwiftUI

struct HistoryView : View {
    
    @State private var searchText : String = ""
    
    @State private var todayItems = [
        "Hôm nay ăn gì hợp lí",
        "Top 10 món ăn cho sức khoẻ tôi",
        "Ngày hôm nay tôi nên ăn gì"
    ]
    
    @State private var yesterdayItems = [
        "1 tuần tới nên ăn gì",
        "Món ăn không tốt cho tôi",
        "Tôi cần làm gì để thay đổi món đó sao cho hợp lí nhất với sức khoẻ tôi"
    ]
    
    var body: some View {
        NavigationStack {
            VStack() {
                // MARK: - Search + Filter
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search...", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    Button {
                        // action
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 22, height: 22)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.black)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                
                // MARK: - List with swipe-to-delete
                List {
                    // Section Today
                    Section(header: Text("Today").font(.headline)) {
                        ForEach(filteredItems(todayItems), id: \.self) { item in
                            HistoryRow(text: item)
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: deleteToday)
                    }
                    .headerProminence(.increased)
                    .listSectionSpacing(2)
                    
                    // Section Yesterday
                    Section(header: Text("Yesterday").font(.headline)) {
                        ForEach(filteredItems(yesterdayItems), id: \.self) { item in
                            HistoryRow(text: item)
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: deleteYesterday)
                    }
                    .headerProminence(.increased)
                }
                .padding(.vertical,12)
                .listStyle(.inset)
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    // MARK: - Helpers
    private func filteredItems(_ items: [String]) -> [String] {
        if searchText.isEmpty { return items }
        return items.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }
    
    private func deleteToday(at offsets: IndexSet) {
        todayItems.remove(atOffsets: offsets)
    }
    
    private func deleteYesterday(at offsets: IndexSet) {
        yesterdayItems.remove(atOffsets: offsets)
    }
    
}

#Preview {
    HistoryView()
}
