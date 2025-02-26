//
//  TeamNewsService.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 25/2/25.
//

class TeamNewsService {
    func getTeamNews(teamId: String, completion: @escaping (Result<[NewsModel], Error>) -> Void) {
        let parameters: [String: String] = [
            "fields": "id, status, title, body, image, team.*, date",
            "filter[team][_eq]": teamId
        ]
        
        Task {
            do {
                let response: NewsModelResponse = try await DirectusService.shared.request(
                    endpoint: "team_news",
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
