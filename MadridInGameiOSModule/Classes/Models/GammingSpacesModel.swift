//
//  GammingSpacesModel.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 4/2/25.
//

// Modelo para la respuesta principal
struct GamingSpaceTimeResponse: Codable {
    let data: [GammingSpacesModel]
}

struct GammingSpacesModel: Codable {
    let id: String
    let dateCreated: String
    let dateUpdated: String
    let notes: String
    let players: [Int]
    let reserves: [Int]
    let startDate: String
    let status: String
    let team: String
    let time: String
    let type: String
    let userCreated: String
    let userUpdated: String

    enum CodingKeys: String, CodingKey {
        case id, notes, players, reserves, status, team, time, type
        case dateCreated = "date_created"
        case dateUpdated = "date_updated"
        case startDate = "start_date"
        case userCreated = "user_created"
        case userUpdated = "user_updated"
    }
}

struct GamingSpaceResponse: Codable {
    let data: [LoanModel]
}

struct GamingSpacesReservationIds: Codable {
    let data: [GamingSpaceReservation]
}

struct GamingSpaceReservation: Codable {
    let id: Int?
    let gamingSpaceReservesId: Int?
    let gamingSpaceTimesId: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case gamingSpaceReservesId = "gaming_space_reserves_id"
        case gamingSpaceTimesId = "gaming_space_times_id"
    }
}

struct LoanModel: Codable {
    let id: Int
    let date: String
    let qrImage: String
    let qrValue: String
    let slot: Int
    let status: String
    let team: String
    let times: [Int]?
    let training: String
    let user: String
    let peripheralLoans: [PeripheralLoan]
    var gammingSpacesTimesComplete: [GamingSpaceReservationTimes] = []

    enum CodingKeys: String, CodingKey {
        case id, date, qrImage, qrValue, slot, status, team, times, training, user
        case peripheralLoans = "peripheral_loans"
    }
}

struct PeripheralLoan: Codable {
    
}

struct GamingSpacesReservationTime: Codable {
    let data: [GamingSpaceReservationTimes]
}

struct GamingSpaceReservationTimes: Codable {
    let id: Int?
    let time: String?
    let value: Int?
    let weekdays: [Int]
}
