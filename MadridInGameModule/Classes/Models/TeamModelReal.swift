//
//  TeamModel 2.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 4/2/25.
//

import Foundation

struct TeamModelReal: Codable, Identifiable {
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
