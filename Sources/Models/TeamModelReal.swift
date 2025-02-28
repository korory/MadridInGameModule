//
//  TeamModel 2.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 4/2/25.
//

import Foundation

//struct TeamModelReal: Codable, Identifiable {
//    let id: String
//    let name: String?
//    let description: String?
//    let picture: String?
//    let status: String?
//    let applyMembership: Int?
//    let discord: String?
//    let dateEdited: String?
//    let users: [TeamUser]?
//    let competitions: [TeamCompetition]?
//
//    enum CodingKeys: String, CodingKey {
//        case id, name, description, picture, status, discord
//        case applyMembership = "apply_membership"
//        case dateEdited = "date_edited"
//        case users, competitions
//    }
//}
//
//struct TeamUser: Identifiable, Codable {
//    let id = UUID()
//    let role: Role?
//    let userId: UserId
//
//    enum CodingKeys: String, CodingKey {
//        case role = "roles"
//        case userId = "users_id"
//    }
//}
//
//struct Role: Codable {
//    let name: String
//}
//
//struct UserId: Codable {
//    let id: String
//    let avatar: String
//    let username: String
//}
//
struct TeamCompetition: Codable {
    let id: String

    enum CodingKeys: String, CodingKey {
        case id = "competitions_id"
    }
}

struct Role: Codable {
    let name: String?
}

struct UserID: Codable {
    let avatar: String?
    let id: String?
    let username: String?
}

struct TeamUser: Identifiable, Codable {
    var id = UUID()
    let roles: Role?
    let usersId: UserID?
    
    enum CodingKeys: String, CodingKey {
        case roles
        case usersId = "users_id"
    }
}

struct TeamModelReal: Codable {
    let applyMembership: Bool?
    let competitions: [TeamCompetition]?
    let dateEdited: String?
    let description: String?
    let discord: String?
    let id: String
    let name: String?
    let picture: String?
    let status: String?
    let users: [TeamUser]?
    
    enum CodingKeys: String, CodingKey {
        case applyMembership = "apply_membership"
        case competitions
        case dateEdited = "date_edited"
        case description
        case discord
        case id
        case name
        case picture
        case status
        case users
    }
}
