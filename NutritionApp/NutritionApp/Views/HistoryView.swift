//
//  HistoryView.swift
//  NutritionApp
//
//  Created by Chỉnh Trần on 3/11/25.
//

import SwiftUI

struct HistoryView: View {
    @State private var searchText: String = ""
    @ObservedObject var store = GlobalChatStore.shared
    
    // Callback truyền lên TabBarView khi nhấn câu hỏi
    var onSelectQuestion: ((UUID) -> Void)?

    var body: some View {
        NavigationStack {
            VStack {
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
                        store.clearHistory()
                    } label: {
                        Image(systemName: "trash")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.red)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                
                // MARK: - List with swipe-to-delete
                List {
                    Section(header: Text("Đã hỏi").font(.headline)) {
                        ForEach(filteredItems(store.questionHistory)) { item in
                            Button {
                                // Khi nhấn → callback
                                onSelectQuestion?(item.id)
                            } label: {
                                HistoryRow(text: item.text)
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        }
                        .onDelete { offsets in
                            store.questionHistory.remove(atOffsets: offsets)
                        }
                    }
                }
                .listStyle(.inset)
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func filteredItems(_ items: [QuestionHistory]) -> [QuestionHistory] {
        if searchText.isEmpty { return items }
        return items.filter { $0.text.localizedCaseInsensitiveContains(searchText) }
    }
}
