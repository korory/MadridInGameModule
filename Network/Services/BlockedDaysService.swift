//
//  BlockedDaysService.swift
//  Pods
//
//  Created by Hamza El Hamdaoui on 24/1/25.
//

import Foundation

class BlockedDaysService {
    let baseURL = "https://premig.randomkesports.com/cms/items/gaming_space_blocked_days"
    let token = "Bearer 8TZMs1jYI1xIts2uyUnE_MJrPQG9KHfY"
    
    func fetchBlockedDates(completion: @escaping (Result<[String], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)?fields=*&filter[date][_gte]=\(DateFormatter.apiDateFormatter.string(from: Date()))") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue(token, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(BlockedDatesResponse.self, from: data)
                let blockedDates = decodedResponse.data.map { $0.date }
                completion(.success(blockedDates))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

struct BlockedDatesResponse: Codable {
    let data: [BlockedDate]
}

struct BlockedDate: Codable {
    let id: Int
    let date: String
    let description: String?
}

// DateFormatter para formatear fechas según el formato esperado por el backend
extension DateFormatter {
    static let apiDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
