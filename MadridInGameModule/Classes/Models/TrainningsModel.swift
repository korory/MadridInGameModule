//
//  TrainningsModel.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 4/2/25.
//

import Foundation

//struct TrainningsResponseModel: Codable {
//    let data: [TrainningsModel]?
//}

struct TrainningsModel: Codable {
    let idUUID = UUID()
    let id: String
    let dateCreated: String
    let dateUpdated: String?
    let notes: String
    let players: [Int]
    let reserves: [Int]
    let startDate: String
    let status: String
    let team: String
    let time: String
    let type: String
    let userCreated: String
    let userUpdated: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case dateCreated = "date_created"
        case dateUpdated = "date_updated"
        case notes
        case players
        case reserves
        case startDate = "start_date"
        case status
        case team
        case time
        case type
        case userCreated = "user_created"
        case userUpdated = "user_updated"
    }
}

struct TrainingUserConnectionModel: Codable {
    let id: Int?
    let trainingsId: String?
    let usersId: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case trainingsId = "trainings_id"
        case usersId = "users_id"
    }
}

struct TrainingUserConnectionResponseModel: Codable {
    let data: [TrainingUserConnectionModel]?
}
