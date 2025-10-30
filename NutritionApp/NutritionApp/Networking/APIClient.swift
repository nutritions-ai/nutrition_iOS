//
//  APIClient.swift
//  NutritionApp
//
//  Created by DaoNA3 on 25/10/25.
//

import Foundation

enum APIClientError: Error, LocalizedError {
    case badURL
    case badResponseStatus(Int)
    case noData
    case invalidJSON
    case serializationError(Error)
    
    var errorDescription: String? {
        switch self {
        case .badURL: return "Không tồn tại URL"
        case .badResponseStatus(let code): return "Lỗi mã HTTP: \(code)"
        case .noData: return "Không có dữ liệu trả về"
        case .invalidJSON: return "Sai định dạng. Dữ liệu trả về không phải là JSON"
        case .serializationError(let error): return "Không thể chuyển đổi dữ liệu: \(error.localizedDescription)"
        }
    }
}

final class APIClient {
    private let session: URLSession
    private let timeout: TimeInterval
    
    static let shared = APIClient()
        
    init(session: URLSession = .shared, timeout: TimeInterval = 20.0) {
        self.session = session
        self.timeout = timeout
    }
    
    func sendRequest(to url: URL,
                     method: String,
                     body: [String: Any]? = nil) async throws -> [String: Any] {
        
        var request = URLRequest(url: url)
        request.httpMethod = method.uppercased()
        request.timeoutInterval = timeout
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                throw APIClientError.serializationError(error)
            }
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let http = response as? HTTPURLResponse else {
            throw APIClientError.noData
        }
        guard (200...299).contains(http.statusCode) else {
            throw APIClientError.badResponseStatus(http.statusCode)
        }
        guard data.count > 0 else {
            throw APIClientError.noData
        }
        
        let obj = try JSONSerialization.jsonObject(with: data, options: [])
        guard let dict = obj as? [String: Any] else {
            throw APIClientError.invalidJSON
        }
        
        return dict
    }
}
