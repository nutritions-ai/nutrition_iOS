//
//  AnalyzeResult.swift
//  NutritionApp
//
//  Created by hung on 6/11/25.
//

import Foundation

struct AnalyzeResult: Codable {
    struct BMI: Codable {
        let value: String
        let status: String // "normal", "high", "low"
        let comment: String
    }

    struct Indicator: Codable, Identifiable {
        
        let id: UUID = UUID() // ✅ auto-generate (không cần decode)
        let name: String
        let value: String
        let unit: String?
        let normal_range: String
        let status: String
        let comment: String

        private enum CodingKeys: String, CodingKey {
            case name, value, unit, normal_range, status, comment
        }
    }

    let bmi: BMI
    let indicators: [Indicator]
    let general_evaluation: String
    let details: String
    let potential_risks: [String]
    let advice: String
}


extension AnalyzeResult {
    static let `default` = AnalyzeResult(
        bmi: AnalyzeResult.BMI(
            value: "0.0",
            status: "normal",
            comment: "BMI chưa được tính"
        ),
        indicators: [
            AnalyzeResult.Indicator(
                name: "Blood Pressure",
                value: "0/0",
                unit: "mmHg",
                normal_range: "90/60 - 120/80",
                status: "normal",
                comment: "Chưa có dữ liệu"
            ),
            AnalyzeResult.Indicator(
                name: "Blood Sugar",
                value: "0",
                unit: "mg/dL",
                normal_range: "70-99",
                status: "normal",
                comment: "Chưa có dữ liệu"
            )
        ],
        general_evaluation: "Chưa có đánh giá",
        details: "Chưa có chi tiết",
        potential_risks: [],
        advice: "Chưa có lời khuyên"
    )
}
