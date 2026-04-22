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
    let type: String?   // league category: "esm" | "junior" | "stormCircuit" | "other"
    let pdfFile: String?
    let image: String?

    enum CodingKeys: String, CodingKey {
        case id
        case dateCreated = "date_created"
        case dateUpdated = "date_updated"
        case startDate = "start_date"
        case title, rules
        case endSignDate = "end_sign_date"
        case overview, details, contact
        case startSignDate = "start_sign_date"
        case teams, splits, game, type
        case pdfFile = "pdf_file"
        case image
    }
}

extension TournamentModel {
    func isRegistrationOpen(now: Date = Date()) -> Bool {
        guard let start = parseSignDate(startSignDate),
              let end = parseSignDate(endSignDate) else { return true }
        return start <= now && now <= end
    }

    private func parseSignDate(_ raw: String?) -> Date? {
        guard let raw else { return nil }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        // Try datetime first (preserves hour), then date-only (start of that day)
        let formats = ["yyyy-MM-dd'T'HH:mm:ss", "yyyy-MM-dd"]
        for format in formats {
            formatter.dateFormat = format
            if let date = formatter.date(from: raw) {
                return date
            }
        }
        return nil
    }
}

struct SplitModel: Codable ,Identifiable {
    let competition: String?
    let dateCreated: String?
    let id: Int?
    let name: String?
    let active: Bool?
    let banner: String?
    let overview: String?
    let details: String?
    let rules: String?
    let contact: String?
    let tournaments: [TournamentModel]?

    enum CodingKeys: String, CodingKey {
        case competition
        case dateCreated = "date_created"
        case id
        case name
        case active
        case banner
        case overview
        case details
        case rules
        case contact
        case tournaments
    }
}

struct TournamentModel: Identifiable, Codable {
    let id: Int?
    let name: String?
    let date: String?
    let dateCreated: String?
    let link: String?
    let split: Int?
    let status: String?
    let type: String?
    let startSignDate: String?
    let endSignDate: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case date
        case dateCreated = "date_created"
        case link
        case split
        case status
        case type
        case startSignDate = "start_sign_date"
        case endSignDate = "end_sign_date"
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
    let priority: Int?

    enum CodingKeys: String, CodingKey {
        case id, status
        case userCreated = "user_created"
        case dateCreated = "date_created"
        case userUpdated = "user_updated"
        case dateUpdated = "date_updated"
        case image, type, name, description, banner, competitions, priority
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
