//
//  SpaceService.swift
//  Pods
//
//  Created by Hamza El Hamdaoui on 24/1/25.
//

import Foundation

struct Space: Identifiable {
    let id: Int
    let device: String
    let description: String
    let slots: [Slot]
}

struct Slot: Codable, Identifiable {
    let id: Int
    let position: String
    let space: Int
}

class SpaceService {
    static let shared = SpaceService()
    
    func fetchSpaces(completion: @escaping (Result<[Space], Error>) -> Void) {
        let url = URL(string: "https://premig.randomkesports.com/cms/items/gaming_space")!
        var request = URLRequest(url: url)
        request.addValue("Bearer 8TZMs1jYI1xIts2uyUnE_MJrPQG9KHfY", forHTTPHeaderField: "Authorization")
        
        let fields = "fields=*,translations.*,slots.*"
        let filter = "filter[group][_eq]=false"
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
                let decodedResponse = try JSONDecoder().decode(SpaceResponse.self, from: data)
                let spaces = decodedResponse.data.compactMap { item -> Space? in
                    guard let translation = item.translations.first(where: { $0.languagesCode == "es" }) else { return nil }
                    return Space(
                        id: item.id,
                        device: translation.device,
                        description: translation.description,
                        slots: item.slots
                    )
                }
                completion(.success(spaces))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

// Modelo de respuesta del JSON
struct SpaceResponse: Codable {
    let data: [SpaceItem]
}

struct SpaceItem: Codable {
    let id: Int
    let group: Bool
    let translations: [Translation]
    let slots: [Slot]
}
