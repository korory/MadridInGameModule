//
//  UserManager.swift
//  Pods
//
//  Created by Hamza El Hamdaoui on 27/1/25.
//

import Foundation

struct Team: Codable, Identifiable {
    let id: String
    let name: String?
    let description: String?
    let picture: String?
    let applyMembership: Bool?
    let status: String?
    let discord: String?
    let dateEdited: String?
    let users: [TeamUser]?
    let competitions: [TeamCompetition]?

    enum CodingKeys: String, CodingKey {
        case id, name, description, picture, status, discord
        case applyMembership = "apply_membership"
        case dateEdited = "date_edited"
        case users, competitions
    }
}

struct TeamUser: Codable {
    let role: Role?
    let userId: UserId

    enum CodingKeys: String, CodingKey {
        case role = "roles"
        case userId = "users_id"
    }
}

struct Role: Codable {
    let id: String
    let name: String
}

struct UserId: Codable {
    let id: String
    let username: String
}

struct TeamCompetition: Codable {
    let id: String

    enum CodingKeys: String, CodingKey {
        case id = "competitions_id"
    }
}

struct User: Codable {
    let id: String
    let status: String
    let username: String
    let email: String
    let dni: String?
    let token: String?
    let firstName: String
    let lastName: String
    let avatar: String?
    let reservesAllowed: Int
    let phone: String?
    let trainings: [Int]
    let gamingSpaceReserves: [Int]
    let invitations: [Int]
    var teams: [Team] = []

    enum CodingKeys: String, CodingKey {
        case id, status, username, email, dni, token, firstName = "first_name", lastName = "last_name", avatar
        case reservesAllowed = "reserves_allowed"
        case phone, trainings, gamingSpaceReserves = "gaming_space_reserves", invitations
    }
}


class UserManager {
    static let shared = UserManager()
    
    private var user: User?
    private let userEndpoint = "https://premig.randomkesports.com/cms/items/users"
    private let teamsEndpoint = "https://premig.randomkesports.com/cms/items/teams"
    private let token = "Bearer 8TZMs1jYI1xIts2uyUnE_MJrPQG9KHfY"
    
    private init() {}
    
    func initializeUser(withEmail email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(userEndpoint)?filter[email][_eq]=\(email)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode([String: [User]].self, from: data)
                
                if let users = response["data"], var user = users.first {
                    self?.user = user
                    
                    self?.fetchTeamsByUser(userId: user.id) { result in
                                    switch result {
                                    case .success(let teams):
                                        user.teams = teams
                                        self?.user = user
                                        completion(.success(()))
                                    case .failure(let error):
                                        completion(.failure(error))
                                    }
                                }
                    completion(.success(()))
                } else {
                    completion(.failure(NSError(domain: "No User Found", code: 0, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }

    func fetchTeamsByUser(userId: String, completion: @escaping (Result<[Team], Error>) -> Void) {
        guard let url = URL(string: "\(teamsEndpoint)?filter[users][users_id][_eq]=\(userId)&fields=id,name,description,picture,apply_membership,status,discord,users.roles.*,users.users_id.id,users.users_id.username,competitions.competitions_id,date_edited") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let teamResponse = try decoder.decode(TeamResponse.self, from: data)
                completion(.success(teamResponse.data))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }

    struct TeamResponse: Codable {
        let data: [Team]
    }

    
    func getUser() -> User? {
        return user
    }
}
