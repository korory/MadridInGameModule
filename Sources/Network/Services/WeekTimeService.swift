//
//  WeekTimeService.swift
//  Pods
//
//  Created by Hamza El Hamdaoui on 24/1/25.
//

import Foundation

struct WeekTime: Identifiable {
    let id: Int
    let time: String
    let value: Int
}

class WeekTimeService {
    static let shared = WeekTimeService()
    
    func fetchWeekTimeByDay(dayValue: Int, completion: @escaping (Result<[WeekData], Error>) -> Void) {
        
        let parameters: [String: String] = [
            "fields": "times.gaming_space_times_id.time,times.gaming_space_times_id.id,times.gaming_space_times_id.value",
            "filter[value][_eq]": String(dayValue)
        ]
        
        Task {
            do {
                let response: WeekTimeResponse = try await DirectusService.shared.request(
                    endpoint: "gaming_space_week_times",
                    method: .GET,
                    parameters: parameters
                )
                
                completion(.success(response.data))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

// Estructura para decodificar la respuesta
struct WeekTimeResponse: Codable {
    let data: [WeekData]
}


struct GamingTime: Codable {
    let gamingSpaceTime: GamingSpaceTime

    enum CodingKeys: String, CodingKey {
        case gamingSpaceTime = "gaming_space_times_id"
    }
}

struct GamingSpaceTime: Codable, Identifiable {
    let id: Int
    let time: String
    let value: Int
}

struct WeekData: Codable {
    let times: [GamingTime]
    
    enum CodingKeys: String, CodingKey {
        case times
    }
}

