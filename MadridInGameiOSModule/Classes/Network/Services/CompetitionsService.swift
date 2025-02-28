//
//  CompetitionsService.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 10/2/25.
//

class CompetitionsService {
    
    func getCompetitions(year: String, completion: @escaping (Result<[CompetitionData], Error>) -> Void) {
        let parameters: [String: String] = [
            "fields": "*,game.*, splits.*, splits.tournaments.*",
            "filter[start_date][_between]": "\(year)-01-01,\(year)-12-31"
        ]
        
        Task {
            do {
                let response: CompetitionDataResponde = try await DirectusService.shared.request(
                    endpoint: "competitions",
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
