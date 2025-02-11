//
//  CompetitionData.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 10/2/25.
//


import SwiftUI

// MARK: - Competition Data Model

struct CompetitionDataResponde: Codable {
    let data: [CompetitionData]
}

// MARK: - Datum
struct CompetitionData: Codable , Identifiable{
    let id, dateCreated: String?
    let dateUpdated: String?
    let startDate, title, rules, endSignDate: String?
    let overview, details, contact: String?
    let startSignDate: String?
    let teams, splits: [Int]?
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

// MARK: - Game
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

//struct CompetitionData: Codable {
//    let id: String
//    let contact: String?
//    let dateCreated: String
//    let dateUpdated: String?
//    let details: String?
//    let endSignDate: String?
//    let game: Game
//    let overview: String?
//    let rules: String?
//    let splits: [Int]?
//    let startDate: String?
//    let startSignDate: String?
//    let teams: [Int]?
//    let title: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case contact
//        case dateCreated = "date_created"
//        case dateUpdated = "date_updated"
//        case details
//        case endSignDate = "end_sign_date"
//        case game
//        case overview
//        case rules
//        case splits
//        case startDate = "start_date"
//        case startSignDate = "start_sign_date"
//        case teams
//        case title
//    }
//
//}
//
//// MARK: - Game Model
//
//struct Game: Codable {
//    let id: String
//    let banner: String?
//    let competitions: [String]?
//    let dateCreated: String
//    let dateUpdated: String?
//    let description: String?
//    let image: String?
//    let name: String?
//    let status: String?
//    let type: String?
//    let userCreated: String?
//    let userUpdated: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case banner
//        case competitions
//        case dateCreated = "date_created"
//        case dateUpdated = "date_updated"
//        case description
//        case image
//        case name
//        case status
//        case type
//        case userCreated = "user_created"
//        case userUpdated = "user_updated"
//    }
//
//}
