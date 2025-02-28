//
//  SpaceService.swift
//  Pods
//
//  Created by Hamza El Hamdaoui on 24/1/25.
//

import Foundation

struct Space: Identifiable, Codable {
    let id: Int
    let device: String
    let description: String
    let slots: [Slot]
}

struct Slot: Codable, Identifiable {
    let id: Int
    let position: String?
    let space: Int?
}

class SpaceService {
    static let shared = SpaceService()
    
    func fetchSpaces(completion: @escaping (Result<[SpaceItem], Error>) -> Void) {
        
        let parameters: [String: String] = [
            "fields": "translations.*,slots.*",
            "filter[group][_eq]": String(false)
        ]
        
        Task {
            do {
                let response: SpaceResponse = try await DirectusService.shared.request(
                    endpoint: "gaming_space",
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

// Modelo de respuesta del JSON
struct SpaceResponse: Codable {
    let data: [SpaceItem]
}

struct SpaceItem: Codable {
    let translations: [Translation]
    let slots: [Slot]
}
