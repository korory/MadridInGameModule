//
//  EventModel.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 10/2/25.
//


import Foundation

//struct EventModelResponse: Codable {
//    let data: [EventModel]
//}

// MARK: - EventModelResponse
struct EventModelResponse: Codable {
    let data: [EventModel]
}

// MARK: - EventModel
struct EventModel: Identifiable, Codable {
    let id, notes: String?
    let players: [PlayerUsersModel]?
    let reserves: [Reserve]?
    let startDate, status, time, type: String

    enum CodingKeys: String, CodingKey {
        case id, notes, players, reserves
        case startDate = "start_date"
        case status, time, type
    }
}

// MARK: - Reserve
struct Reserve: Codable {
    let date: String?
    let id: Int?
    let peripheralLoans: [PeripheralLoan]?
    let qrImage, qrValue: String?
    let slot: Int?
    let status: String?
    let team: Team?
    let times: [Time]?
    let training, user: String?

    enum CodingKeys: String, CodingKey {
        case date, id
        case peripheralLoans = "peripheral_loans"
        case qrImage, qrValue, slot, status, team, times, training, user
    }
}

struct ReserveResponseModel: Codable {
    let data: ReserveResponse
}

struct ReserveResponse: Codable {
    let date: String?
    let id: Int?
    let peripheralLoans: [PeripheralLoan]?
    let qrImage, qrValue: String?
    let slot: Int?
    let status: String?
    let team: String?
    let times: [Int]?
    let training, user: String?

    enum CodingKeys: String, CodingKey {
        case date, id
        case peripheralLoans = "peripheral_loans"
        case qrImage, qrValue, slot, status, team, times, training, user
    }
}

struct PlayerUsersModel: Identifiable, Codable {
    let id = UUID()
    let userId: PlayerModel?
    
    enum CodingKeys: String, CodingKey {
        case userId = "users_id"
    }
}

// MARK: - Team
struct Team: Codable {
    let name: String?
    let picture: String?

    enum CodingKeys: String, CodingKey {
        case name, picture
    }
}

// MARK: - Time
struct Time: Codable {
    let gamingSpaceTimesID: GamingSpaceTimesID?

    enum CodingKeys: String, CodingKey {
        case gamingSpaceTimesID = "gaming_space_times_id"
    }
}

// MARK: - GamingSpaceTimesID
struct GamingSpaceTimesID: Codable {
    let time: String?
}

//struct EventModel: Codable {
//    var id: String
//    var notes: String
//    var players: [Int]
//    var reserves: [Int]
//    var startDate: String
//    var status: String
//    var time: String
//    var type: String
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case notes
//        case players
//        case reserves
//        case startDate = "start_date"
//        case status
//        case time
//        case type
//    }
//}
