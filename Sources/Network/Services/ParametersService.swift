import Foundation

struct AppParametersResponse: Codable {
    let data: AppParameters
}

struct AppParameters: Codable {
    let id: Int
    let reservesSingleLimit: Int
    let trainingsTeamLimit: Int
    let teamNewsLimit: Int
    let maxTeamPlayers: Int
}

class ParametersService {
    static let shared = ParametersService()
    private init() {}

    func fetchParameters(completion: @escaping (Result<AppParameters, Error>) -> Void) {
        Task {
            do {
                let response: AppParametersResponse = try await DirectusService.shared.request(
                    endpoint: "parameters",
                    method: .GET
                )
                completion(.success(response.data))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
