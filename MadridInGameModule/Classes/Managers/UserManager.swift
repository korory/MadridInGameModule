//
//  UserManager.swift
//  Pods
//
//  Created by Hamza El Hamdaoui on 27/1/25.
//

import Foundation

class UserManager {
    static let shared = UserManager()
    
    private var user: UserModel?

    private init() {}
    
    func initializeUser(withEmail email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let parameters = ["filter[email][_eq]": email]

        Task {
            do {
                let response: [String: [UserModel]] = try await DirectusService.shared.request(
                    endpoint: "users",
                    method: .GET,
                    parameters: parameters
                )

                if let users = response["data"], var user = users.first {
                    self.user = user

                    fetchTeamsByUser(userId: user.id) { result in
                        switch result {
                        case .success(let teams):
                            user.teams = teams
                            self.user = user
                            completion(.success(()))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } else {
                    completion(.failure(NSError(domain: "No User Found", code: 0, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func fetchTeamsByUser(userId: String, completion: @escaping (Result<[TeamModelReal], Error>) -> Void) {
        let parameters = ["filter[users][users_id][_eq]": userId]
        let fields = "id,name,description,picture,apply_membership,status,discord,users.roles.*,users.users_id.id,users.users_id.username,competitions.competitions_id,date_edited"

        Task {
            do {
                let response: TeamResponse = try await DirectusService.shared.request(
                    endpoint: "teams",
                    method: .GET,
                    parameters: parameters.merging(["fields": fields]) { _, new in new }
                )

                completion(.success(response.data))
            } catch {
                completion(.failure(error))
            }
        }
    }


    struct TeamResponse: Codable {
        let data: [TeamModelReal]
    }

    
    func getUser() -> UserModel? {
        return user
    }
}
