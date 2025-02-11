//
//  CompetitionData.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 10/2/25.
//


import SwiftUI

struct CompetitionDataResponde: Codable {
    let data: [CompetitionData]
}

struct CompetitionData: Codable , Identifiable{
    let id, dateCreated: String?
    let dateUpdated: String?
    let startDate, title, rules, endSignDate: String?
    let overview, details, contact: String?
    let startSignDate: String?
    let teams: [Int]?
    let splits: [SplitModel]?
    let game: Game?

    enum CodingKeys: String, CodingKey {
        case id
        case dateCreated = "date_created"
        case dateUpdated = "date_updated"
        case startDate = "start_date"
        case title, rules
        case endSignDate = "end_sign_date"
        case overview, details, contact
        case startSignDate = "start_sign_date"
        case teams, splits, game
    }
}

struct SplitModel: Codable ,Identifiable {
    let competition: String
    let dateCreated: String
    let id: Int
    let name: String
    let tournaments: [TournamentModel]
    
    enum CodingKeys: String, CodingKey {
        case competition
        case dateCreated = "date_created"
        case id
        case name
        case tournaments
    }
}

struct TournamentModel: Identifiable, Codable {
    let id: Int
    let name: String
    let date: String
    let dateCreated: String
    let link: String
    let split: Int
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case date
        case dateCreated = "date_created"
        case link
        case split
        case status
    }
}


struct Game: Codable ,Identifiable{
    let id: String?
    let status: String?
    let userCreated, dateCreated: String?
    let userUpdated, dateUpdated: String?
    let image, type, name, description: String?
    let banner: String?
    let competitions: [String]?

    enum CodingKeys: String, CodingKey {
        case id, status
        case userCreated = "user_created"
        case dateCreated = "date_created"
        case userUpdated = "user_updated"
        case dateUpdated = "date_updated"
        case image, type, name, description, banner, competitions
    }
}

//struct CompetitionModel: Codable, Identifiable {
//    let contact: String
//    let dateCreated: String
//    let dateUpdated: String
//    let details: String
//    let endSignDate: String
//    let game: String
//    let id: String
//    let overview: String
//    let rules: String
//    let splits: [Int]
//    let startDate: String
//    let startSignDate: String
//    let teams: [String] // Cambia el tipo si los equipos tienen un modelo específico
//    let title: String
//    
//    enum CodingKeys: String, CodingKey {
//        case contact
//        case dateCreated = "date_created"
//        case dateUpdated = "date_updated"
//        case details
//        case endSignDate = "end_sign_date"
//        case game
//        case id
//        case overview
//        case rules
//        case splits
//        case startDate = "start_date"
//        case startSignDate = "start_sign_date"
//        case teams
//        case title
//    }
//}
