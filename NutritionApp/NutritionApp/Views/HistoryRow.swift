//
//  HistoryRow.swift
//  NutritionApp
//
//  Created by Chỉnh Trần on 3/11/25.
//

import SwiftUI

struct HistoryRow: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.system(size: 15, weight: .medium))
            .foregroundColor(.gray.opacity(0.8))
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemBackground))
            .padding(.vertical, 14)
            .padding(.horizontal, 12)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal, 2)
    }
}

#Preview {
    HistoryRow(text: "abc")
}
