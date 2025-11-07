//
//  Test.swift
//  NutritionApp
//
//  Created by hung on 5/11/25.
//



import Foundation
import UIKit

let OPENAI_API_KEY = "sk-e33XdbP5qVj57ONqvLnrpw"
let BASE_URL = "https://aiportalapi.stu-platform.live/jpe/v1/chat/completions"

func imageToBase64(_ image: UIImage) -> String? {
    guard let imageData = image.jpegData(compressionQuality: 0.8) else { return nil }
    return imageData.base64EncodedString()
}

func extractTextFromImage(_ image: UIImage) {
    guard let base64Image = imageToBase64(image) else {
        print("⚠️ Failed to encode image.")
        return
    }

    guard let url = URL(string: BASE_URL) else {
        print("⚠️ Invalid base URL.")
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("Bearer \(OPENAI_API_KEY)", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    let body: [String: Any] = [
        "model": "gpt-4o-mini",
        "messages": [
            [
                "role": "user",
                "content": [
                    ["type": "text", "text": "Analyze this image"],
                    [
                        "type": "image_url",
                        "image_url": [
                            "url": "data:image/jpeg;base64,\(base64Image)"
                        ]
                    ]
                ]
            ]
        ]
    ]

    request.httpBody = try? JSONSerialization.data(withJSONObject: body)

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("❌ Network error: \(error.localizedDescription)")
            return
        }

        guard let data = data else {
            print("⚠️ No data received")
            return
        }

        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let choices = json["choices"] as? [[String: Any]],
           let message = choices.first?["message"] as? [String: Any],
           let content = message["content"] as? String {
            print("🧾 Extracted text:\n\(content)")
        } else {
            print("⚠️ Response: \(String(data: data, encoding: .utf8) ?? "")")
        }
    }.resume()
}

let analyze_result = """
{"bmi":{"value":"17.3","status":"low","comment":"BMI thấp, có dấu hiệu thiếu cân."},"indicators":[{"name":"Hemoglobin (HGB)","value":"10.8","unit":"g/dL","normal_range":"13.0–17.0","status":"low","comment":"Hemoglobin thấp, có thể là dấu hiệu thiếu máu."},{"name":"Hematocrit (HCT)","value":"33","unit":"%","normal_range":"39–50","status":"low","comment":"Hematocrit thấp, có thể liên quan đến tình trạng thiếu máu."},{"name":"WBC","value":"12.6","unit":"x10^3/µL","normal_range":"4.0–10.0","status":"high","comment":"Số lượng bạch cầu cao, có thể chỉ ra tình trạng nhiễm trùng hoặc viêm."},{"name":"Glucose (Fasting)","value":"142","unit":"mg/dL","normal_range":"70–99","status":"high","comment":"Đường huyết cao, có thể là dấu hiệu tiểu đường."},{"name":"Creatinine","value":"1.45","unit":"mg/dL","normal_range":"0.6–1.2","status":"high","comment":"Creatinine cao, có thể chỉ ra vấn đề về chức năng thận."},{"name":"eGFR","value":"56","unit":"mL/min/1.73m²","normal_range":">60","status":"low","comment":"eGFR thấp, có thể cho thấy suy giảm chức năng thận."},{"name":"Total Cholesterol","value":"218","unit":"mg/dL","normal_range":"<200","status":"high","comment":"Cholesterol toàn phần cao, có thể tăng nguy cơ bệnh tim mạch."},{"name":"LDL-C","value":"142","unit":"mg/dL","normal_range":"<100","status":"high","comment":"LDL-C cao, có thể làm tăng nguy cơ bệnh tim."},{"name":"HDL-C","value":"38","unit":"mg/dL","normal_range":">40","status":"low","comment":"HDL-C thấp, có thể làm tăng nguy cơ bệnh tim."},{"name":"Triglycerides","value":"165","unit":"mg/dL","normal_range":"<150","status":"high","comment":"Triglycerides cao, có thể liên quan đến nguy cơ bệnh tim."},{"name":"WBC (Microscopy)","value":"8-12","unit":"/HPF","normal_range":"<5","status":"high","comment":"Số lượng bạch cầu trong nước tiểu cao, có thể chỉ ra nhiễm trùng."},{"name":"Protein trong nước tiểu","value":"Trace","unit":null,"normal_range":"Âm tính","status":"high","comment":"Có dấu vết protein trong nước tiểu, cần kiểm tra chức năng thận."},{"name":"Glucose trong nước tiểu","value":"Positive","unit":null,"normal_range":"Âm tính","status":"high","comment":"Có glucose trong nước tiểu, có thể là dấu hiệu tiểu đường."},{"name":"Leukocyte esterase","value":"Positive","unit":null,"normal_range":"Âm tính","status":"high","comment":"Có dấu hiệu viêm hoặc nhiễm trùng."},{"name":"Nitrite","value":"Positive","unit":null,"normal_range":"Âm tính","status":"high","comment":"Có thể chỉ ra nhiễm trùng đường tiểu."}],"general_evaluation":"Nhiều chỉ số bất thường, có dấu hiệu thiếu máu, tiểu đường và vấn đề về thận.","details":"Kết quả xét nghiệm cho thấy tình trạng sức khỏe tổng thể không ổn định. Cần chú ý đến các chỉ số như glucose, creatinine và các chỉ số viêm nhiễm trong nước tiểu. Cần theo dõi và điều trị kịp thời để tránh các biến chứng.","potential_risks":["Tiểu đường","Bệnh thận","Thiếu máu","Nhiễm trùng đường tiểu"],"advice":"Cần đi khám bác sĩ để được chẩn đoán và điều trị kịp thời. Theo dõi chế độ ăn uống, tăng cường dinh dưỡng, uống đủ nước và tập thể dục thường xuyên."}
"""
