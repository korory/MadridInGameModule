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
    
    func fetchWeekTimeByDay(dayValue: Int, completion: @escaping (Result<[GamingSpaceTime], Error>) -> Void) {
        let url = URL(string: "https://premig.randomkesports.com/cms/items/gaming_space_week_times")! // Reemplaza con la URL correcta
        var request = URLRequest(url: url)
        request.addValue("Bearer 8TZMs1jYI1xIts2uyUnE_MJrPQG9KHfY", forHTTPHeaderField: "Authorization") // Reemplaza `YOUR_TOKEN`
        
        let fields = "fields=*,times.gaming_space_times_id.time,times.gaming_space_times_id.id,times.gaming_space_times_id.value"
        let filter = "filter[value][_eq]=\(dayValue)"
        request.url = URL(string: "\(url)?\(fields)&\(filter)")!
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(WeekTimeResponse.self, from: data)
                let times = decodedResponse.data.flatMap { week in
                    week.times.map { $0.gamingSpaceTime }
                }
                completion(.success(times.sorted(by: { $0.value < $1.value })))
            } catch {
                completion(.failure(error))
            }
        }.resume()
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
    let id: Int
    let weekday: String
    let value: Int
    let times: [GamingTime]
    
    enum CodingKeys: String, CodingKey {
        case id, weekday, value, times
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        weekday = try container.decode(String.self, forKey: .weekday)
        value = try container.decode(Int.self, forKey: .value)
        
        // Decodifica el array de tiempos con la clave personalizada
        let timesContainer = try container.decode([GamingTime].self, forKey: .times)
        times = timesContainer
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(weekday, forKey: .weekday)
        try container.encode(value, forKey: .value)
        try container.encode(times, forKey: .times)
    }
}

